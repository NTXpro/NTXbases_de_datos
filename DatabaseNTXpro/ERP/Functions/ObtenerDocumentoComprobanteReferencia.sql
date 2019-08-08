
CREATE FUNCTION [ERP].[ObtenerDocumentoComprobanteReferencia](@IdComprobante INT)
RETURNS VARCHAR(50)
AS
BEGIN
		DECLARE @Documento VARCHAR(50) = (SELECT TOP 1 R.Documento
									FROM ERP.ComprobanteReferencia R
									WHERE R.IdComprobante = @IdComprobante)
		RETURN @Documento

END
