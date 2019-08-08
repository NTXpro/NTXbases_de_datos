
CREATE PROCEDURE ERP.Usp_SelComprobanteRetencionDetalle
@IdComprobanteRetencion INT
AS
	SELECT IdTipoComprobante, 
			C.Serie,
			C.Documento, 
			C.Fecha,
			C.IdMoneda,
			MO.CodigoSunat Moneda, 
			C.Total,
			CRD.ID,
			CRD.IdComprobanteRetencion,
			CRD.IdSaldoInicial,
			CRD.IdComprobante,
			CRD.Orden,
			CRD.MontoPagadoSoles, 
			CRD.MontoRetenidoSoles
	FROM ERP.ComprobanteRetencionDetalle CRD
	INNER JOIN ERP.Comprobante C ON C.ID = CRD.IdComprobante	
	INNER JOIN Maestro.Moneda MO ON C.IdMoneda = MO.ID	
	WHERE @IdComprobanteRetencion = IdComprobanteRetencion
	UNION	
	SELECT IdTipoComprobante, 
			SIC.Serie,
			SIC.Documento, 
			SIC.Fecha,
			SIC.IdMoneda,
			MO.CodigoSunat Moneda, 
			SIC.Monto AS 'Total',
			CRD.ID,
			CRD.IdComprobanteRetencion,
			CRD.IdSaldoInicial,
			CRD.IdComprobante,
			CRD.Orden,
			CRD.MontoPagadoSoles, 
			CRD.MontoRetenidoSoles
	FROM ERP.ComprobanteRetencionDetalle CRD
	INNER JOIN ERP.SaldoInicialCobrar SIC ON SIC.ID = CRD.IdSaldoInicial
	INNER JOIN Maestro.Moneda MO ON SIC.IdMoneda = MO.ID	
	WHERE @IdComprobanteRetencion = IdComprobanteRetencion
	ORDER BY Orden
