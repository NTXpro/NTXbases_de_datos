
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteCuenta_SaldoCuenta]
@IdEmpresa INT,
@IdAnio INT,
@IdMoneda INT,
@FlagAllCuenta BIT,
@CuentaContableDesde VARCHAR(25),
@CuentaContableHasta VARCHAR(25)
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	/***************************************************************************************/
	DECLARE @CADENA VARCHAR(30) = '000000000000000000000000000000';
	DECLARE @MAX_LEN INT = (SELECT MAX(LEN(CuentaContable)) FROM ERP.PlanCuenta);
	DECLARE @TOTAL_CEROS VARCHAR(30) = (SELECT SUBSTRING(@CADENA, 1, @MAX_LEN));
	DECLARE @CC_DESDE INT = CAST(LEFT(@CuentaContableDesde + @TOTAL_CEROS, @MAX_LEN) AS INT)
	DECLARE @CC_HASTA INT = CAST(LEFT(@CuentaContableHasta + @TOTAL_CEROS, @MAX_LEN) AS INT)
	/***************************************************************************************/

	INSERT INTO @DataInvalida
	SELECT 
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	WHERE 
	P.IdAnio = @IdAnio AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT
		TEMP.CuentaContable,
		PC2.Nombre
	FROM
	(SELECT
		SUBSTRING(PC.CuentaContable, 1, 2) AS CuentaContable,
		M.Valor,
		--ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
		--ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) AS Saldo
		CASE 
			WHEN @IdMoneda = 1 THEN
				ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
				ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
			WHEN @IdMoneda = 2 THEN
				ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0) -
				ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0)
		END AS Saldo
	FROM
	ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor <= 12 AND
	(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1
	GROUP BY PC.CuentaContable, M.Valor
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) <> 0 ) AS TEMP
	INNER JOIN ERP.PlanCuenta PC2 ON TEMP.CuentaContable = PC2.CuentaContable AND PC2.IdAnio = @IdAnio AND PC2.IdEmpresa = @IdEmpresa
	GROUP BY TEMP.CuentaContable, PC2.Nombre
	ORDER BY TEMP.CuentaContable
END
