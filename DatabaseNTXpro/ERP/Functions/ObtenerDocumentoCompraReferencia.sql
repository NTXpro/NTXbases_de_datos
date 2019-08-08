CREATE FUNCTION [ERP].[ObtenerDocumentoCompraReferencia](@IdCompra INT)
RETURNS VARCHAR(50)
AS
BEGIN
		DECLARE @DOCUMENTO VARCHAR(50) = (SELECT TOP 1 R.Documento
									FROM ERP.CompraReferencia R
									WHERE R.IdCompra = @IdCompra)
		RETURN @DOCUMENTO
END
