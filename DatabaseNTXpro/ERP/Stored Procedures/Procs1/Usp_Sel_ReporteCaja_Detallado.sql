CREATE PROCEDURE [ERP].[Usp_Sel_ReporteCaja_Detallado]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMoneda INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes)

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
	M.Valor BETWEEN 0 AND @VALOR_MES AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT
		PC.ID,
		PC.CuentaContable,
		PC.Nombre,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END ELSE 0 END ), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END ELSE 0 END ), 0)
		END AS Debe,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END ELSE 0 END ), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END ELSE 0 END ), 0)
		END AS Haber
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID	
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PC.CuentaContable LIKE '10%' AND
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1
	GROUP BY PC.ID, PC.CuentaContable, PC.Nombre
	HAVING
	ISNULL(SUM(AD.ImporteSoles), 0) <> 0
	ORDER BY PC.CuentaContable ASC
END
