CREATE FUNCTION [ERP].[ObtenerTipoComprobanteComprobanteReferencia](@IdComprobante INT)
RETURNS VARCHAR(50)
AS
BEGIN
		DECLARE @TC VARCHAR(50) = (SELECT TOP 1 T10.CodigoSunat
									FROM ERP.ComprobanteReferencia R
									LEFT JOIN PLE.T10TipoComprobante T10
									ON R.IdTipoComprobante = T10.ID 
									WHERE R.IdComprobante = @IdComprobante)
		RETURN @TC

END
