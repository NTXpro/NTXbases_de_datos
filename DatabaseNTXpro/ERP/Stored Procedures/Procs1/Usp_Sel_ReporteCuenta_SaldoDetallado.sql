
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteCuenta_SaldoDetallado]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMoneda INT,
@FlagAllCuenta BIT,
@CuentaContableDesde VARCHAR(25),
@CuentaContableHasta VARCHAR(25),
@IdGrado INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes);
	/***************************************************************************************/
	DECLARE @CADENA VARCHAR(30) = '000000000000000000000000000000';
	DECLARE @MAX_LEN INT = (SELECT MAX(LEN(CuentaContable)) FROM ERP.PlanCuenta);
	DECLARE @TOTAL_CEROS VARCHAR(30) = (SELECT SUBSTRING(@CADENA, 1, @MAX_LEN));
	DECLARE @CC_DESDE INT = CAST(LEFT(@CuentaContableDesde + @TOTAL_CEROS, @MAX_LEN) AS INT);
	DECLARE @CC_HASTA INT = CAST(LEFT(@CuentaContableHasta + @TOTAL_CEROS, @MAX_LEN) AS INT);
	/***************************************************************************************/
	DECLARE @LONGITUD INT = (SELECT TOP 1 Longitud FROM Maestro.Grado WHERE ID = @IdGrado)
		
	INSERT INTO @DataInvalida
	SELECT 
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	WHERE 
	P.IdAnio = @IdAnio AND
	M.Valor <= @MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT
		LEFT(PC.CuentaContable, @LONGITUD) AS CuentaContable,
		PC2.Nombre,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) AS SaldoSoles,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0) -
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0) AS SaldoDolares
	FROM
	ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	INNER JOIN ERP.PlanCuenta PC2 ON LEFT(PC.CuentaContable, @LONGITUD) = PC2.CuentaContable AND PC2.IdEmpresa = @IdEmpresa AND PC2.IdAnio = @IdAnio
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor <= 12 AND
	(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1
	GROUP BY LEFT(PC.CuentaContable, @LONGITUD), PC2.Nombre
	HAVING
	LEN(LEFT(PC.CuentaContable, @LONGITUD)) = @LONGITUD AND
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) <> 0 
	ORDER BY LEFT(PC.CuentaContable, @LONGITUD)
	
END
