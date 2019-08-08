CREATE FUNCTION [ERP].[ObtenerSerieComprobanteReferencia](@IdComprobante INT)
RETURNS VARCHAR(50)
AS
BEGIN
		DECLARE @Serie VARCHAR(50) = (SELECT TOP 1 R.Serie
									FROM ERP.ComprobanteReferencia R
									WHERE R.IdComprobante = @IdComprobante)
		RETURN @Serie

END
