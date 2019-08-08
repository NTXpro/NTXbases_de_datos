
CREATE PROC [ERP].[Usp_Export_DocumentoPagar]
@ListaTipoComprobante VARCHAR(MAX),
@FechaVencimiento DATETIME,
@ListaProveedor VARCHAR(MAX),
@TipoFecha INT,
@IdPeriodo INT,
@IdEmpresa INT
AS
BEGIN

WITH LISTA_TEMP AS (
	SELECT	PRO.ID IdProveedor,
			CAST(1 AS INT) IdDebeHaber,
			CP.IdTipoComprobante,
			CP.IdPeriodo,
			CP.IdEmpresa,
			CP.Flag,
			CAST(0 AS BIT) FlagBorrador,
			CP.Fecha,
			CP.FechaVencimiento,
			CASE WHEN CP.IdTipoComprobante IN (8,55,60,183,178) THEN
				(SELECT [ERP].[TotalAplicacionAjustePagarDeSolesPorFecha](CP.ID, @FechaVencimiento)) - IIF(CP.IdMoneda = 1 ,CP.Total,'0.0000')
			ELSE
				IIF(CP.IdMoneda = 1 ,CP.Total,'0.0000') - (SELECT [ERP].[TotalAplicacionAjustePagarDeSolesPorFecha](CP.ID, @FechaVencimiento))
			END AS TotalCPSoles,
			CASE WHEN CP.IdTipoComprobante IN (8,55,60,183,178) THEN
				(SELECT [ERP].[TotalAplicacionAjustePagarDeDolaresPorFecha](CP.ID, @FechaVencimiento)) - IIF(CP.IdMoneda = 2 ,CP.Total,'0.0000')
			ELSE
				IIF(CP.IdMoneda = 2 ,CP.Total,'0.0000') - (SELECT [ERP].[TotalAplicacionAjustePagarDeDolaresPorFecha](CP.ID, @FechaVencimiento))
			END AS TotalCPDolares,
			CASE WHEN CP.IdTipoComprobante IN (8,55,60,183,178) THEN
				(SELECT [ERP].[TotalAplicacionAjustePagarDeConvSolesPorFecha](CP.ID, @FechaVencimiento)) - IIF(CP.IdMoneda = 1 ,CP.Total,CP.Total * CP.TipoCambio)
			ELSE
				IIF(CP.IdMoneda = 1 ,CP.Total,CP.Total * CP.TipoCambio) - (SELECT [ERP].[TotalAplicacionAjustePagarDeConvSolesPorFecha](CP.ID, @FechaVencimiento))
			END AS TotalCPConvSoles,
			CASE WHEN CP.IdTipoComprobante IN (8,55,60,183,178) THEN
				(SELECT [ERP].[TotalAplicacionAjustePagarDeConvDolaresPorFecha](CP.ID, @FechaVencimiento)) - IIF(CP.IdMoneda = 2 ,CP.Total,CP.Total/CP.TipoCambio)
			ELSE
				IIF(CP.IdMoneda = 2 ,CP.Total,CP.Total/CP.TipoCambio) - (SELECT [ERP].[TotalAplicacionAjustePagarDeConvDolaresPorFecha](CP.ID, @FechaVencimiento))
			END AS TotalCPConvDolares,
			--IIF(CP.IdMoneda = 1 ,CP.Total,'0.0000')*IIF(CP.IdTipoComprobante = 8,-1,1) AS TotalCPSoles,
			--IIF(CP.IdMoneda = 2 ,CP.Total,'0.0000')*IIF(CP.IdTipoComprobante = 8,-1,1) AS TotalCPDolares,
			--IIF(CP.IdMoneda = 1 ,CP.Total,CP.Total * CP.TipoCambio)*IIF(CP.IdTipoComprobante = 8,-1,1) TotalCPConvSoles,
			--IIF(CP.IdMoneda = 2 ,CP.Total,CP.Total/CP.TipoCambio)*IIF(CP.IdTipoComprobante = 8,-1,1) AS TotalCPConvDolares,

			CAST(0 AS DECIMAL(14,2)) AS TotalMovimientoCPSoles,
			CAST(0 AS DECIMAL(14,2)) AS TotalMovimientoCPDolares,
			CAST(0 AS DECIMAL(14,2)) AS TotalMovimientoConvSoles,
			CAST(0 AS DECIMAL(14,2)) AS TotalMovimientoConvDolares,

			CAST(0 AS DECIMAL(14,2)) AS TotalAnticipoCPSoles,
			CAST(0 AS DECIMAL(14,2)) AS TotalAnticipoCPDolares,
			CAST(0 AS DECIMAL(14,2)) AS TotalAnticipoConvSoles,
			CAST(0 AS DECIMAL(14,2)) AS TotalAnticipoConvDolares
	FROM ERP.CuentaPagar CP
	INNER JOIN ERP.Entidad ENT ON ENT.ID = CP.IdEntidad
	INNER JOIN ERP.Proveedor PRO ON PRO.IdEntidad = ENT.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = ENT.ID
	LEFT JOIN ERP.AplicacionAnticipoPagar AAA ON AAA.IdCuentaPagar = CP.ID 

	UNION ALL

	SELECT 
	PRO.ID IdProveedor,
	CAST(MTD.IdDebeHaber AS INT) IdDebeHaber,
	CP.IdTipoComprobante,
	CAST(0 AS INT) IdPeriodo,
	MT.IdEmpresa,
	MT.Flag,
	CAST(MT.FlagBorrador AS BIT) FlagBorrador,
	MT.Fecha,
	MT.Fecha FechaVencimiento,
	CAST(0 AS DECIMAL(14,2)) as TotalCPSoles,
	CAST(0 AS DECIMAL(14,2)) as TotalCPDolares,
	CAST(0 AS DECIMAL(14,2)) as TotalCPConvSoles,
	CAST(0 AS DECIMAL(14,2)) as TotalCPConvDolares,

	IIF(CP.IdMoneda = 1 ,MTD.Total,'0.0000')*IIF(CP.IdTipoComprobante IN (8,55,60,183,178),-1,1) AS TotalMovimientoCPSoles,
	IIF(CP.IdMoneda = 2 AND MT.IdMoneda = 2,MTD.Total,IIF(CP.IdMoneda = 2 AND MT.IdMoneda = 1,MTD.Total / MT.TipoCambio,'0.0000'))*IIF(CP.IdTipoComprobante IN (8,55,60,183,178),-1,1)  AS TotalMovimientoCPDolares,
	IIF(CP.IdMoneda = 1 ,MTD.Total,MTD.Total * CP.TipoCambio)*IIF(CP.IdTipoComprobante IN (8,55,60,183,178),-1,1) TotalMovimientoConvSoles,
	IIF(CP.IdMoneda = 2 ,MTD.Total,MTD.Total/CP.TipoCambio)*IIF(CP.IdTipoComprobante IN (8,55,60,183,178),-1,1) as TotalMovimientoConvDolares,
	
	CAST(0 AS DECIMAL(14,2)) AS TotalAnticipoCPSoles,
	CAST(0 AS DECIMAL(14,2)) AS TotalAnticipoCPDolares,
	CAST(0 AS DECIMAL(14,2)) AS TotalAnticipoConvSoles,
	CAST(0 AS DECIMAL(14,2)) AS TotalAnticipoConvDolares

	FROM ERP.MovimientoTesoreriaDetalleCuentaPagar MDCP
	INNER JOIN ERP.CuentaPagar CP ON CP.ID = MDCP.IdCuentaPagar
	INNER JOIN ERP.Entidad ENT ON ENT.ID = CP.IdEntidad
	INNER JOIN ERP.Proveedor PRO ON PRO.IdEntidad = ENT.ID
	INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCP.IdMovimientoTesoreriaDetalle
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
),LISTA_TEMP_TOTAL AS (
SELECT ROW_NUMBER() OVER (ORDER BY IdProveedor) AS RowNumber,
	   IdProveedor ID,
	   IdProveedor,
	   E.Nombre NombreProveedor,
	   ETD.NumeroDocumento RUC,	
	   SUM(ROUND(ISNULL(TEMP.TotalCPSoles,0) - ISNULL(TEMP.TotalMovimientoCPSoles,0),2)) AS SaldoSoles,
	   SUM(ROUND(ISNULL(TEMP.TotalCPDolares,0) - ISNULL(TEMP.TotalMovimientoCPDolares,0),2)) AS SaldoDolares,
	   SUM(ROUND(ISNULL(TEMP.TotalCPConvSoles,0) - ISNULL(TEMP.TotalMovimientoConvSoles,0),2)) AS SaldoConvSoles,
	   SUM(ROUND(ISNULL(TEMP.TotalCPConvDolares,0) - ISNULL(TEMP.TotalMovimientoConvDolares,0),2)) AS SaldoConvDolares
FROM LISTA_TEMP TEMP
INNER JOIN ERP.Proveedor P ON P.ID = TEMP.IdProveedor
INNER JOIN ERP.Entidad E ON E.ID = P.IdEntidad
INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
WHERE TEMP.Flag = 1  AND TEMP.FlagBorrador = 0 AND TEMP.IdDebeHaber = 1
AND TEMP.IdProveedor IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaProveedor,','))
AND TEMP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
AND ((@TipoFecha = 1 AND CAST(TEMP.Fecha AS DATE)<= CAST(@FechaVencimiento AS DATE)) OR (@TipoFecha = 2 AND CAST(TEMP.FechaVencimiento AS DATE)<= CAST(@FechaVencimiento AS DATE)))
AND (IdPeriodo = 0 OR IdPeriodo <= @IdPeriodo)
AND TEMP.IdEmpresa = @IdEmpresa
GROUP BY TEMP.IdProveedor,E.Nombre,ETD.NumeroDocumento
Having
CAST((SUM(ROUND(ISNULL(TEMP.TotalCPSoles,0) - ISNULL(TEMP.TotalMovimientoCPSoles,0),2))) AS DECIMAL(14,2)) != 0 OR CAST((SUM(ROUND(ISNULL(TEMP.TotalCPDolares,0) - ISNULL(TEMP.TotalMovimientoCPDolares,0),2))) AS DECIMAL(14,2)) != 0
),COUNT_TEMP AS (
SELECT COUNT(ID) AS [TotalCount]
FROM LISTA_TEMP_TOTAL
)
SELECT RowNumber,
	   ID,
	   IdProveedor,
	   NombreProveedor,
	   RUC,
	   SaldoSoles,
	   SaldoDolares,
	   SaldoConvSoles,
	   SaldoConvDolares
FROM LISTA_TEMP_TOTAL TEMP
END