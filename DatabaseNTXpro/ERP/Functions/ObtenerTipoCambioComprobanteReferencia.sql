CREATE FUNCTION [ERP].[ObtenerTipoCambioComprobanteReferencia] (@IdComprobante INT) 
RETURNS VARCHAR(50)
AS
BEGIN
		DECLARE @TipoCambioVenta VARCHAR(50) = (SELECT TipoCambio FROM ERP.Comprobante WHERE ID = @IdComprobante)

		DECLARE @TipoCambio VARCHAR(50) = (SELECT TOP 1 (C.TipoCambio)
									FROM ERP.ComprobanteReferencia R
									LEFT JOIN ERP.Comprobante C
									ON R.IdReferencia = C.ID
									LEFT JOIN ERP.Comprobante CM
									ON CM.ID = R.IdComprobante
									LEFT JOIN PLE.T10TipoComprobante T10
									ON C.IdTipoComprobante = T10.ID 
									WHERE R.IdComprobante = @IdComprobante
)
		RETURN ISNULL(CAST(@TipoCambio AS VARCHAR(50)),@TipoCambioVenta)
END