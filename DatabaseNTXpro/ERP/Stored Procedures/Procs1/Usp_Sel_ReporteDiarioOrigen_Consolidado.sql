--[ERP].[Usp_Sel_ReporteDiario_Consolidado]  1,7,3,1,'0','9'
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteDiarioOrigen_Consolidado]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMoneda INT,
@AbreviaturaDesde VARCHAR(25),
@AbreviaturaHasta VARCHAR(25)
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
		O.ID AS IdOrigen,
		O.Abreviatura,
		O.Nombre AS NombreOrigen,
		PC.ID AS IdPlanCuenta,
		PC.CuentaContable,
		PC.Nombre AS NombrePlanCuenta,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) AS Debe,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) AS Haber
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
	(@IdMoneda = 1 OR A.IdMoneda = @IdMoneda) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	(O.Abreviatura BETWEEN (@AbreviaturaDesde + '%') AND (@AbreviaturaHasta + '%') 
	OR CuentaContable LIKE @AbreviaturaHasta + '%') AND
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1
	GROUP BY 
		O.ID,
		O.Abreviatura,
		O.Nombre,
		PC.ID,
		PC.CuentaContable,
		PC.Nombre
	ORDER BY O.Abreviatura, PC.CuentaContable ASC
END

