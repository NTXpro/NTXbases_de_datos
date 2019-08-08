
CREATE FUNCTION [ERP].[ObtenerFechaComprobanteReferencia](@IdComprobante INT)
RETURNS VARCHAR(50)
AS
BEGIN
		DECLARE @Fecha VARCHAR(50) = (SELECT TOP 1 CAST(C.Fecha AS DATE)
									FROM ERP.ComprobanteReferencia R
									LEFT JOIN ERP.Comprobante C
									ON R.IdReferencia = C.ID
									LEFT JOIN ERP.Comprobante CM
									ON CM.ID = R.IdComprobante
									LEFT JOIN PLE.T10TipoComprobante T10
									ON C.IdTipoComprobante = T10.ID 
									WHERE R.IdComprobante = @IdComprobante)
		RETURN CAST(@Fecha AS VARCHAR(50))
END
