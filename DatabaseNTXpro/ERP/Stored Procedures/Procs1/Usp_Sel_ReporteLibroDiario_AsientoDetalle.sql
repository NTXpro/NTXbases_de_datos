CREATE PROCEDURE [ERP].[Usp_Sel_ReporteLibroDiario_AsientoDetalle] --1,9,6
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdAsiento INT
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
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
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
		CONVERT(VARCHAR, A.Fecha, 103) AS FechaStr,
		A.Nombre AS Glosa,
		PC.CuentaContable AS Codigo,
		PC.Nombre AS Denominacion,
		ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END, 0) AS Debe,
		ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END, 0) AS Haber
	FROM
	Maestro.Origen O
	INNER JOIN ERP.Asiento A ON O.ID = A.IdOrigen
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	WHERE
	A.FlagBorrador = 0 AND
	A.Flag = 1 AND
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	P.IdMes = @IdMes AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	A.ID = @IdAsiento
END