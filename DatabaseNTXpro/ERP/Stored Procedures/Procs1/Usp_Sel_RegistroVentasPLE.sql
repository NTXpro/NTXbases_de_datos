CREATE PROC [ERP].[Usp_Sel_RegistroVentasPLE]
@IdEmpresa INT,
@idAnio VARCHAR(4),
@idMes	VARCHAR(2)
AS
BEGIN
	SELECT	
			CONCAT(@idAnio,@idMes,'00')	Periodo,
			CONCAT('04',RIGHT('000000' + CAST(A.Orden AS VARCHAR(8)), 7))			Asiento,
			CONCAT('M',CONCAT('04',RIGHT('000000' + CAST(A.Orden AS VARCHAR(8)), 7)))		Asiento2,
			C.Fecha						FechaRegistro,
			C.Fecha						FechaVencimiento,
			T10.CodigoSunat				TipoComprobante,
			C.Serie						Serie,
			C.Documento					Documento,
			''							Col9,
			T2.CodigoSunat				TipoDocumentoCliente,
			ETD.NumeroDocumento			NumeroDocumento,
			IIF(C.IdComprobanteEstado = 3,'ANULADO',E.Nombre)	RazonSocial,
			CASE WHEN C.IdMoneda = 1 THEN
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleExportacion) * IIF(T10.CodigoSunat = '07', -1, 1)
			ELSE
				--IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleExportacion * (SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('TCV',C.Fecha))) * IIF(T10.CodigoSunat = '07', -1, 1)
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleExportacion * IIF(T10.CodigoSunat='07',(SELECT [ERP].[ObtenerTipoCambioComprobanteReferencia](C.ID)),(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',C.Fecha)))) * IIF(T10.CodigoSunat = '07', -1, 1)
			END							TotalDetalleExportacion,
			CASE WHEN C.IdMoneda = 1 THEN
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleAfecto) * IIF(T10.CodigoSunat = '07', -1, 1)
			ELSE
				--IIF(C.IdComprobanteEstado = 3 ,'0.00',C.SubTotal * (SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('TCV',C.Fecha))) * IIF(T10.CodigoSunat = '07', -1, 1)
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleAfecto * IIF(T10.CodigoSunat='07',(SELECT [ERP].[ObtenerTipoCambioComprobanteReferencia](C.ID)),(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',C.Fecha)))) * IIF(T10.CodigoSunat = '07', -1, 1)
			END							SubTotal,
			CASE WHEN C.IdMoneda = 1 THEN
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.ImporteDescuento) * IIF(T10.CodigoSunat = '07', -1, 1)
			ELSE
				--IIF(C.IdComprobanteEstado = 3 ,'0.00',C.ImporteDescuento * (SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('TCV',C.Fecha))) * IIF(T10.CodigoSunat = '07', -1, 1)
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.ImporteDescuento * IIF(T10.CodigoSunat='07',(SELECT [ERP].[ObtenerTipoCambioComprobanteReferencia](C.ID)),(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',C.Fecha)))) * IIF(T10.CodigoSunat = '07', -1, 1)
			END							ImporteDescuento,
			CASE WHEN C.IdMoneda = 1 THEN
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.IGV) * IIF(T10.CodigoSunat = '07', -1, 1)
			ELSE
				--IIF(C.IdComprobanteEstado = 3 ,'0.00',C.IGV * (SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('TCV',C.Fecha))) * IIF(T10.CodigoSunat = '07', -1, 1)
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.IGV * IIF(T10.CodigoSunat='07',(SELECT [ERP].[ObtenerTipoCambioComprobanteReferencia](C.ID)),(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',C.Fecha)))) * IIF(T10.CodigoSunat = '07', -1, 1)
			END							IGV,
			'0.00'								Col17,
			CASE WHEN C.IdMoneda = 1 THEN
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleInafecto) * IIF(T10.CodigoSunat = '07', -1, 1)
			ELSE
				--IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleInafecto * (SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('TCV',C.Fecha))) * IIF(T10.CodigoSunat = '07', -1, 1)
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleInafecto * IIF(T10.CodigoSunat='07',(SELECT [ERP].[ObtenerTipoCambioComprobanteReferencia](C.ID)),(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',C.Fecha)))) * IIF(T10.CodigoSunat = '07', -1, 1)
			END									Col18,
			CASE WHEN C.IdMoneda = 1 THEN
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleInafecto) * IIF(T10.CodigoSunat = '07', -1, 1)
			ELSE
				--IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleInafecto * (SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('TCV',C.Fecha))) * IIF(T10.CodigoSunat = '07', -1, 1)
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.TotalDetalleInafecto * IIF(T10.CodigoSunat='07',(SELECT [ERP].[ObtenerTipoCambioComprobanteReferencia](C.ID)),(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',C.Fecha)))) * IIF(T10.CodigoSunat = '07', -1, 1)
			END									Col19,
			'0.00'						Col20,
			'0.00'						Col21,
			'0.00'						Col22,
			'0.00'						Col23,
			CASE WHEN C.IdMoneda = 1 THEN
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.Total) * IIF(T10.CodigoSunat = '07', -1, 1)
			ELSE
				--IIF(C.IdComprobanteEstado = 3 ,'0.00',C.Total * (SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('TCV',C.Fecha))) * IIF(T10.CodigoSunat = '07', -1, 1)
				IIF(C.IdComprobanteEstado = 3 ,'0.00',C.Total * IIF(T10.CodigoSunat='07',(SELECT [ERP].[ObtenerTipoCambioComprobanteReferencia](C.ID)),(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',C.Fecha)))) * IIF(T10.CodigoSunat = '07', -1, 1)
			END Total,
			M.CodigoSunat,
			--(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('TCV',C.Fecha))				TipoCambio,
			iif(T10.CodigoSunat='07',(SELECT [ERP].[ObtenerTipoCambioComprobanteReferencia](C.ID)),(SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT',C.Fecha))) TipoCambio,
			(SELECT(ERP.ObtenerFechaComprobanteReferencia(C.ID)))						FechaRef,
			(SELECT(ERP.ObtenerTipoComprobanteComprobanteReferencia(C.ID)))				Col28,
			(SELECT(ERP.ObtenerSerieComprobanteReferencia(C.ID)))					Col29,
			(SELECT(ERP.ObtenerDocumentoComprobanteReferencia(C.ID)))				Col30,
			''							Col31,
			''							Col32,
			''							Col33,
			IIF(C.IdComprobanteEstado = 3 ,2,1)							CodOportunidad
FROM ERP.Comprobante C
INNER JOIN ERP. Asiento A
ON C.IdAsiento = A.ID
INNER JOIN PLE.T10TipoComprobante T10
ON C.IdTipoComprobante = T10.ID
INNER JOIN ERP.Cliente Cl
ON C.IdCliente = Cl.ID AND C.IdEmpresa = Cl.IdEmpresa
INNER JOIN ERP.EntidadTipoDocumento ETD
ON Cl.IdEntidad = ETD.IdEntidad
INNER JOIN ERP.Entidad E
ON ETD.IdEntidad = E.ID
INNER JOIN PLE.T2TipoDocumento T2
ON ETD.IdTipoDocumento = T2.ID
INNER JOIN Maestro.Moneda M
ON C.IdMoneda = M.ID
INNER JOIN ERP.Empresa EM
ON C.IdEmpresa = EM.ID
WHERE C.IdEmpresa = @IdEmpresa AND MONTH(C.Fecha) = @idMes AND YEAR(C.FECHA) = @idAnio AND C.Flag = 1 AND C.FlagBorrador = 0 AND C.IdComprobanteEstado IN (2,3)
ORDER BY T10.CodigoSunat, C.Serie, C.Documento ASC
END