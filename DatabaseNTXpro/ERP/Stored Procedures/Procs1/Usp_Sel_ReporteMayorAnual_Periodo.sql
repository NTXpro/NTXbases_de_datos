
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteMayorAnual_Periodo]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMesHasta INT,
@IdMoneda INT,
@FlagAllCuenta BIT,
@CuentaContableDesde VARCHAR(25),
@CuentaContableHasta VARCHAR(25),
@IdEntidad INT,
@IdPlanCuenta INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes)
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta)

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
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

    SELECT 
		P.IdMes AS IdMes,
		RIGHT('00' + LTRIM(RTRIM(M.Valor)), 2) AS Valor,
		PC.CuentaContable,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END ELSE 0 END ), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END ELSE 0 END ), 0)
		END AS DebeAcumulado,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END ELSE 0 END ), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END ELSE 0 END ), 0)
		END AS HaberAcumulado,
		A.IdPeriodo AS ID,
		CONCAT(AN.Nombre, RIGHT('00' + LTRIM(RTRIM(M.Valor)), 2)) AS Nombre,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor >= @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END ELSE 0 END ), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor >= @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END ELSE 0 END ), 0)
		END AS Debe,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor >= @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END ELSE 0 END ), 0)
			WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor >= @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END ELSE 0 END ), 0)
		END AS Haber,
		CASE WHEN M.Valor < @VALOR_MES_DESDE THEN 0 ELSE 1 END AS Flag
	FROM
	ERP.PlanCuenta PC
	LEFT JOIN ERP.AsientoDetalle AD ON PC.ID = AD.IdPlanCuenta
	LEFT JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	LEFT JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	LEFT JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	LEFT JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	LEFT JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN ERP.Entidad EN ON AD.IdEntidad = EN.ID
	LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = EN.ID	
	LEFT JOIN PLE.T10TipoComprobante TC ON AD.IdTipoComprobante = TC.ID
	WHERE
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	PC.IdEmpresa = @IdEmpresa AND
	(@IdEntidad = 0 OR AD.IdEntidad = @IdEntidad) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PC.ID = @IdPlanCuenta AND
	---------------------
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	GROUP BY A.IdPeriodo, AN.Nombre, M.Valor, P.IdMes, M.Valor, PC.CuentaContable
	ORDER BY AN.Nombre, M.Valor ASC
END
