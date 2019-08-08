CREATE PROCEDURE [ERP].[Usp_Sel_ReporteEstadoSituacionFinanciera_Detalle] --4,8,1,10,1,'40115001'
@IdEmpresa INT,
@IdAnio INT,
@IdMesDesde INT,
@IdMesHasta INT,
@IdMoneda INT,
@CuentaContable VARCHAR(25)
AS
BEGIN

	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesDesde);
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta);
	SET @VALOR_MES_DESDE = CASE WHEN @VALOR_MES_DESDE = 1 THEN 0 ELSE @VALOR_MES_DESDE END;

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
	M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT 
		A.ID,
		O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) AS Comprobante,
		ISNULL(AD.Fecha, A.Fecha) AS Fecha,
		ETD.NumeroDocumento AS NumeroDocumento,
		AD.Nombre AS Glosa,
		AD.Documento,			
		ISNULL(TCD.VentaSunat, A.TipoCambio) AS TipoCambio,
		ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END, 0) AS Debe,
		ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END, 0) AS Haber,
		ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END, 0) -
		ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END, 0) AS Saldo
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	LEFT JOIN ERP.Entidad EN ON AD.IdEntidad = EN.ID
	LEFT JOIN [ERP].[TipoCambioDiario] TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN [PLE].[T10TipoComprobante] TC ON AD.IdTipoComprobante = TC.ID
	LEFT JOIN [ERP].[EntidadTipoDocumento] ETD ON ETD.IdEntidad = EN.ID	
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PC.CuentaContable LIKE @CuentaContable + '%' AND
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	ORDER BY
	A.Fecha,
	O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) ASC
	

END