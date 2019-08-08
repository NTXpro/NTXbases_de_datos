CREATE FUNCTION [ERP].[ObtenerSerieCompraReferencia](@IdCompra INT)
RETURNS VARCHAR(50)
AS
BEGIN
		DECLARE @SERIE VARCHAR(50) = (SELECT TOP 1 R.Serie
									FROM ERP.CompraReferencia R
									WHERE R.IdCompra = @IdCompra)
		RETURN @SERIE
END
