CREATE PROCEDURE [ERP].[Usp_Sel_ReporteDiarioOrigen]
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
		O.ID,
		O.Abreviatura,
		O.Nombre,
		--ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) AS Debe,
		--ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) AS Haber
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0)
		END AS Debe,
		CASE
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0)
		END AS Haber
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
	--(@IdMoneda = 1 OR A.IdMoneda = @IdMoneda) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	(LEN(ISNULL(@AbreviaturaDesde, '')) = 0 OR CAST(O.Abreviatura AS INTEGER) >= CAST(@AbreviaturaDesde AS INTEGER)) AND 
	(LEN(ISNULL(@AbreviaturaHasta, '')) = 0 OR CAST(O.Abreviatura AS INTEGER) <= CAST(@AbreviaturaHasta AS INTEGER)) AND	
	A.FlagBorrador = 0 AND
	A.Flag = 1
	GROUP BY O.ID, O.Abreviatura, O.Nombre
	ORDER BY O.Abreviatura ASC
END