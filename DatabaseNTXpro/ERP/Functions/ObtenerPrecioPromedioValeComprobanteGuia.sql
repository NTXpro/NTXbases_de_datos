CREATE FUNCTION [ERP].[ObtenerPrecioPromedioValeComprobanteGuia](@IdComprobante INT, @IdGuia INT, @IdProducto INT)
RETURNS DECIMAL(14,5)
AS
BEGIN
		DECLARE @PrecioPromedio DECIMAL(14,5) = (SELECT PrecioUnitario FROM ERP.ValeDetalle WHERE IdVale = @IdComprobante AND IdProducto = @IdProducto
												UNION
												SELECT PrecioUnitario FROM ERP.ValeDetalle WHERE IdVale = @IdGuia AND IdProducto = @IdProducto)
		RETURN @PrecioPromedio
END
