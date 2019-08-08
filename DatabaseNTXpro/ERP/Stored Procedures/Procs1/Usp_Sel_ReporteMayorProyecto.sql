
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteMayorProyecto]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMesHasta INT,
@IdMoneda INT,
@FlagAllCuenta BIT,
@CuentaContableDesde VARCHAR(25),
@CuentaContableHasta VARCHAR(25),
@IdProyecto INT,
@IdEntidad INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes);
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta);
	/******************************************************************************/
	DECLARE @CADENA VARCHAR(30) = '000000000000000000000000000000';
	DECLARE @MAX_LEN INT = (SELECT MAX(LEN(CuentaContable)) FROM ERP.PlanCuenta);
	DECLARE @TOTAL_CEROS VARCHAR(30) = (SELECT SUBSTRING(@CADENA, 1, @MAX_LEN));
	DECLARE @CC_DESDE INT = CAST(LEFT(@CuentaContableDesde + @TOTAL_CEROS, @MAX_LEN) AS INT)
	DECLARE @CC_HASTA INT = CAST(LEFT(@CuentaContableHasta + @TOTAL_CEROS, @MAX_LEN) AS INT)
	/******************************************************************************/

	INSERT INTO @DataInvalida
	SELECT 
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	WHERE 
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT 
		PR.ID,
		PR.Numero,
		PR.Nombre,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) AS Debe,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) AS Haber
	FROM
	ERP.Proyecto PR
	INNER JOIN ERP.AsientoDetalle AD ON PR.ID = AD.IdProyecto
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	(@IdProyecto = 0 OR PR.ID = @IdProyecto) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
	---------------------
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	GROUP BY PR.ID, PR.Numero, PR.Nombre
	ORDER BY PR.Numero
END
