
--[ERP].[Usp_Sel_ReporteDiarioAuxiliar_Comprobante] 4,8,1,1
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteDiarioAuxiliar_Comprobante]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMoneda INT
AS
BEGIN
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes) - 1 
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
	M.Valor BETWEEN 0 AND (@VALOR_MES_HASTA + 1) AND
	A.IdEmpresa = @IdEmpresa AND 
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT 
		0 AS IdOrigen,
		'' AS Abreviatura,
		0 AS IdAsiento,
		0 AS Orden,
		'' AS Comprobante,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0)
		END AS Debe,
		CASE
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0)
		END AS Haber
	FROM 
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE
	A.FlagBorrador = 0 AND
	A.Flag = 1 AND
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1

	UNION ALL

	SELECT 
		O.ID AS IdOrigen,
		O.Abreviatura,
		A.ID AS IdAsiento,
		A.Orden,
		CONCAT(O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7), ' - ', A.Nombre) AS Comprobante,
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
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1
	GROUP BY O.ID, O.Abreviatura, A.ID, A.Orden, A.Nombre
END
