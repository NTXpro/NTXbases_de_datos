
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteCuenta_SaldoCuenta_Consolidado]
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
		CuentaContable,
		Nombre,
		ISNULL(Apertura, 0) AS Apertura,
		ISNULL(Enero, 0) AS Enero,
		ISNULL(Febrero, 0) AS Febrero,
		ISNULL(Marzo, 0) AS Marzo,
		ISNULL(Abril, 0) AS Abril,
		ISNULL(Mayo, 0) AS Mayo,
		ISNULL(Junio, 0) AS Junio,
		ISNULL(Julio, 0) AS Julio,
		ISNULL(Agosto, 0) AS Agosto,
		ISNULL(Setiembre, 0) AS Setiembre, 
		ISNULL(Octubre, 0) AS Octubre,
		ISNULL(Noviembre, 0) AS Noviembre,
		ISNULL(Diciembre, 0) AS Diciembre,
		ISNULL(Apertura, 0) +
		ISNULL(Enero, 0) +
		ISNULL(Febrero, 0) +
		ISNULL(Marzo, 0) +
		ISNULL(Abril, 0) +
		ISNULL(Mayo, 0) +
		ISNULL(Junio, 0) +
		ISNULL(Julio, 0) +
		ISNULL(Agosto, 0) +
		ISNULL(Setiembre, 0) +
		ISNULL(Octubre, 0) +
		ISNULL(Noviembre, 0) +
		ISNULL(Diciembre, 0) AS Acumulado
	FROM
	(SELECT
		PC.CuentaContable,
		PC.Nombre,
		M.Nombre AS NombreMes,
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
	M.Valor BETWEEN 0 AND 12 AND
	(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1
	GROUP BY PC.CuentaContable, PC.Nombre, M.Nombre
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) <> 0 ) AS TEMP
	PIVOT
	(
		SUM(TEMP.Saldo)
		FOR TEMP.NombreMes IN 
			(Apertura, 
			 Enero, 
			 Febrero, 
			 Marzo,
			 Abril,
			 Mayo,
			 Junio,
			 Julio,
			 Agosto,
			 Setiembre,
			 Octubre,
			 Noviembre,
			 Diciembre)
	) AS P ORDER BY CuentaContable
END
