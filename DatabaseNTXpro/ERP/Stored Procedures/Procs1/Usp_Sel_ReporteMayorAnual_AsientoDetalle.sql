
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteMayorAnual_AsientoDetalle]
@IdEmpresa INT,
@IdAnio INT,
@IdMesHasta INT,
@IdMoneda INT,
@IdEntidad INT,
@IdPlanCuenta INT,
@IdPeriodo INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @MES_ACUMULADO INT = (SELECT Valor FROM Maestro.Mes WHERE ID = (SELECT IdMes FROM ERP.Periodo WHERE ID = @IdPeriodo));
	DECLARE @MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta);

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
	A.IdPeriodo = @IdPeriodo AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT 
		A.IdPeriodo,
		O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) AS Comprobante,
		ISNULL(AD.Fecha, A.Fecha) AS Fecha, -- FECHA TIPO COMPROBANTE
		ETD.NumeroDocumento AS NumeroDocumento,
		A.Nombre AS Glosa,
		TC.Nombre AS NombreTipoComprobante,
		AD.Documento,
		AD.Serie,
		ISNULL(TCD.VentaSunat, A.TipoCambio) AS TipoCambio, -- TIPO DE CAMBIO-
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END, 0)
		END AS Debe,

		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END, 0)
		END AS Haber,
		CASE
			WHEN PC.IdMoneda = 2 AND @IdMoneda = 1 THEN ISNULL(CASE WHEN AD.IdDebeHaber = 2 THEN AD.ImporteDolares * -1 ELSE AD.ImporteDolares END, 0)
			ELSE 0
		END AS Dolares,
		PC.CuentaContable,
		RIGHT('00' + LTRIM(RTRIM(M.Valor)),2) AS Valor
	FROM
	PlanCuenta PC
	LEFT JOIN AsientoDetalle AD ON PC.ID = AD.IdPlanCuenta
	LEFT JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	LEFT JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	LEFT JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	LEFT JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN ERP.Entidad EN ON AD.IdEntidad = EN.ID
	LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = EN.ID	
	LEFT JOIN PLE.T10TipoComprobante TC ON AD.IdTipoComprobante = TC.ID
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	PC.IdEmpresa = @IdEmpresa AND
	(@IdEntidad = 0 OR AD.IdEntidad = @IdEntidad) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PC.ID = @IdPlanCuenta AND
	M.Valor BETWEEN 0 AND @MES_HASTA AND
	---------------------
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	ORDER BY M.Valor,O.Abreviatura, A.Orden
END