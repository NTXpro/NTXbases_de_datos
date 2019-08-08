CREATE PROC [ERP].[Usp_Paginate_DocumentoCobrar]
@ListaTipoComprobante VARCHAR(MAX),
@Fecha			DATETIME,
@ListaCliente VARCHAR(MAX),
@TipoFecha INT,
---------------------------------
@RowsPerPage		INT,		  -- CANTIDAD A MOSTRAR PORPAGINA
@Page				INT,	      -- NUMERO DE PAGINA
@SortColumn			VARCHAR(100), -- COLUMNA
@SortDirection		VARCHAR(100) -- ORDENAMIENTO
AS
BEGIN

WITH LISTA_TEMP AS (
	SELECT	CLI.ID IdCliente,
			CAST(2 AS INT) IdDebeHaber,
			CC.IdTipoComprobante,
			CC.IdPeriodo,
			CC.Flag,
			CAST(0 AS BIT) FlagBorrador,
			CC.Fecha,
			CC.FechaVencimiento,
			IIF(CC.IdMoneda = 1 ,CC.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1) AS TotalCCSoles,
			IIF(CC.IdMoneda = 2 ,CC.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1) AS TotalCCDolares,
			IIF(CC.IdMoneda = 1 ,CC.Total,CC.Total * CC.TipoCambio)*IIF(CC.IdTipoComprobante = 8,-1,1) AS TotalCCConvSoles,
			IIF(CC.IdMoneda = 2 ,CC.Total,CC.Total/CC.TipoCambio)*IIF(CC.IdTipoComprobante = 8,-1,1) AS TotalCCConvDolares,

			CAST(0 AS DECIMAL(14,2)) AS TotalMovimientoCCSoles,
			CAST(0 AS DECIMAL(14,2)) AS TotalMovimientoCCDolares,
			CAST(0 AS DECIMAL(14,2)) AS TotalMovimientoConvSoles,
			CAST(0 AS DECIMAL(14,2)) AS TotalMovimientoConvDolares

	FROM ERP.CuentaCobrar CC
	INNER JOIN ERP.Entidad ENT ON ENT.ID = CC.IdEntidad
	INNER JOIN ERP.Cliente CLI ON CLI.IdEntidad = ENT.ID

	UNION ALL

	SELECT 
	CLI.ID IdCliente,
	CAST(MTD.IdDebeHaber AS INT) IdDebeHaber,
	CC.IdTipoComprobante,
	CAST(0 AS INT) IdPeriodo,
	MT.Flag,
	CAST(MT.FlagBorrador AS BIT) FlagBorrador,
	MT.Fecha,
	MT.Fecha FechaVencimiento,
	CAST(0 AS DECIMAL(14,2)) as TotalCPSoles,
	CAST(0 AS DECIMAL(14,2)) as TotalCPDolares,
	CAST(0 AS DECIMAL(14,2)) as TotalCPConvSoles,
	CAST(0 AS DECIMAL(14,2)) as TotalCPConvDolares,

	IIF(CC.IdMoneda = 1 ,MTD.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1) AS TotalMovimientoCCSoles,
	IIF(CC.IdMoneda = 2 ,MTD.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1)  AS TotalMovimientoCCDolares,
	IIF(CC.IdMoneda = 1 ,MTD.Total,MTD.Total * CC.TipoCambio)*IIF(CC.IdTipoComprobante = 8,-1,1) AS TotalMovimientoConvSoles,
	IIF(CC.IdMoneda = 2 ,MTD.Total,MTD.Total/CC.TipoCambio)*IIF(CC.IdTipoComprobante = 8,-1,1) AS TotalMovimientoConvDolares

	FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
	INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MDCC.IdCuentaCobrar
	INNER JOIN ERP.Entidad ENT ON ENT.ID = CC.IdEntidad
	INNER JOIN ERP.Cliente CLI ON CLI.IdEntidad = ENT.ID
	INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
	INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
),LISTA_TEMP_TOTAL AS (
SELECT ROW_NUMBER() OVER (ORDER BY IdCliente) AS RowNumber,
	   IdCliente ID,
	   IdCliente,
	   E.Nombre NombreCliente,
	   ETD.NumeroDocumento RUC,	
	   SUM(ISNULL(TEMP.TotalCCSoles,0)) - SUM(ISNULL(TEMP.TotalMovimientoCCSoles,0)) as SaldoSoles,
	   SUM(ISNULL(TEMP.TotalCCDolares,0)) - SUM(ISNULL(TEMP.TotalMovimientoCCDolares,0)) as SaldoDolares,
	   SUM(ISNULL(TEMP.TotalCCConvSoles,0)) - SUM(ISNULL(TEMP.TotalMovimientoConvSoles,0)) as SaldoConvSoles,
	   SUM(ISNULL(TEMP.TotalCCConvDolares,0)) - SUM(ISNULL(TEMP.TotalMovimientoConvDolares,0)) as SaldoConvDolares
FROM LISTA_TEMP TEMP
INNER JOIN ERP.Cliente C ON C.ID = TEMP.IdCliente
INNER JOIN ERP.Entidad E ON E.ID = C.IdEntidad
INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
WHERE TEMP.Flag = 1  AND TEMP.FlagBorrador = 0 AND TEMP.IdDebeHaber = 2
AND TEMP.IdCliente IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaCliente,','))
AND TEMP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
AND ((@TipoFecha = 1 AND CAST(TEMP.Fecha AS DATE)<= CAST(@Fecha AS DATE)) OR (@TipoFecha = 2 AND CAST(TEMP.FechaVencimiento AS DATE)<= CAST(@Fecha AS DATE)))
GROUP BY TEMP.IdCliente,E.Nombre,ETD.NumeroDocumento
Having
CAST((SUM(ISNULL(TEMP.TotalCCSoles,0)) - SUM(ISNULL(TEMP.TotalMovimientoCCSoles,0))) AS DECIMAL(14,2)) > 0 OR CAST((SUM(ISNULL(TEMP.TotalCCDolares,0)) - SUM(ISNULL(TEMP.TotalMovimientoCCDolares,0))) AS DECIMAL(14,2)) > 0
),COUNT_TEMP AS (
SELECT COUNT(ID) AS [TotalCount]
FROM LISTA_TEMP_TOTAL
)
SELECT RowNumber,
	   ID,
	   IdCliente,
	   NombreCliente,
	   RUC,
	   SaldoSoles,
	   SaldoDolares,
	   SaldoConvSoles,
	   SaldoConvDolares,
	   TotalCount
FROM LISTA_TEMP_TOTAL,COUNT_TEMP TEMP
WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
END
