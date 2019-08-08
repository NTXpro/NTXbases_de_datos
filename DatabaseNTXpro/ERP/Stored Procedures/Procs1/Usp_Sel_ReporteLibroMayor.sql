CREATE PROCEDURE [ERP].[Usp_Sel_ReporteLibroMayor] -- 1, 9, 6
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes)

	INSERT INTO @DataInvalida
	SELECT
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE 
	P.IdAnio = @IdAnio AND
	P.IdMes = @IdMes AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL
	
	SELECT
		M.Valor,
		PC.CuentaContable,
		REPLACE(REPLACE(PC.Nombre,CHAR(10),''),CHAR(13),'') AS NombreCuentaContable,
		ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END, 0) AS SaldoDebe,
		ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END, 0) AS SaldoHaber,
		CONVERT(VARCHAR, A.Fecha, 103) AS FechaStr,
		O.Abreviatura,
		A.Orden,
		CONCAT(O.Abreviatura, RIGHT('000000' + LTRIM(RTRIM(A.Orden)), 6)) AS Correlativo,
		A.Nombre AS Glosa,
		ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END, 0) AS Debe,
		ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END, 0) AS Haber
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	PC.IdEmpresa = @IdEmpresa AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	ORDER BY PC.CuentaContable, O.Abreviatura, A.Orden
END