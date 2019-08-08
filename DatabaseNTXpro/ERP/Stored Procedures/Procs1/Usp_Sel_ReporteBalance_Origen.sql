CREATE PROC [ERP].[Usp_Sel_ReporteBalance_Origen] --4,8,1,9,1,'12',115
@IdEmpresa INT,
@IdAnio INT,
@IdMesDesde INT,
@IdMesHasta INT,
@IdMoneda INT,
@CuentaContable VARCHAR(25),
@IdPeriodo INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesDesde);
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta);

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
	P.ID = @IdPeriodo AND
	A.IdEmpresa =  @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
		ISNULL(SUM(CASE
						WHEN AD.IdDebeHaber = 1 AND A.IdMoneda = 2 THEN AD.ImporteDolares
						WHEN AD.IdDebeHaber = 1 AND A.IdMoneda = 1 THEN AD.ImporteSoles
					END), 0)
		 <> ISNULL(SUM(CASE
						WHEN AD.IdDebeHaber = 2 AND A.IdMoneda = 2 THEN AD.ImporteDolares
						WHEN AD.IdDebeHaber = 2 AND A.IdMoneda = 1 THEN AD.ImporteSoles
					END), 0)
	--ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	--ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT
		@CuentaContable AS CuentaContable,
		P.ID AS IdPeriodo,
		O.ID AS IdOrigen,
		CONCAT(O.Abreviatura, ' - ', O.Nombre) AS NombreOrigen,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN @IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END), 0) AS Debe,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN @IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END), 0) AS Haber/*,
		CASE WHEN M.Valor < @VALOR_MES_DESDE THEN 0 ELSE 1 END AS FlagInicial*/
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PC.CuentaContable LIKE @CuentaContable + '%' AND
	P.ID = @IdPeriodo AND
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	GROUP BY
	P.ID,
	M.Valor,
	O.ID, 
	O.Nombre, 
	O.Abreviatura
	ORDER BY
	CAST(O.Abreviatura AS INT)
END