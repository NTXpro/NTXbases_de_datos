
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteCuenta_SaldoMes]
@IdEmpresa INT,
@IdAnio INT,
@CuentaContable VARCHAR(25),
@IdMoneda INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);

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
	TEMP.ID,
	TEMP.Valor,
	TEMP.NombreMes,
	SUM(TEMP.Debe) AS Debe,
	SUM(TEMP.Haber) AS Haber,
	SUM(TEMP.Debe) - SUM(TEMP.Haber) AS Saldo,
	SUM(SUM(TEMP.Debe) - SUM(TEMP.Haber)) OVER(ORDER BY TEMP.Valor) AS Acumulado
	FROM
	(
	SELECT ID, Valor, Nombre AS NombreMes,0 AS Debe, 0 AS Haber FROM Maestro.Mes
	UNION
	SELECT
		M.ID,
		M.Valor AS Valor,
		M.Nombre AS NombreMes,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0)
		END AS Debe,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0)
		END AS Haber
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
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PC.CuentaContable = @CuentaContable AND
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1
	GROUP BY M.ID, M.Valor, M.Nombre
	
	) AS TEMP
	GROUP BY TEMP.ID, TEMP.Valor, TEMP.NombreMes
	ORDER BY TEMP.Valor
END
