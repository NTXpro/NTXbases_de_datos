

CREATE FUNCTION [ERP].[ObtenerPrecioUnitarioProductoGratuito_By_ComprobanteDetalle](
@IdComprobanteDetalle INT
)
RETURNS DECIMAL(15,5)
AS
BEGIN
	
	DECLARE @IdListaPrecio INT = (SELECT IdListaPrecio FROM ERP.Comprobante C INNER JOIN ERP.ComprobanteDetalle CD ON C.ID = CD.IdComprobante WHERE CD.ID = @IdComprobanteDetalle)
	DECLARE @IdProducto INT = (SELECT IdProducto FROM ERP.ComprobanteDetalle WHERE ID = @IdComprobanteDetalle)
	DECLARE @PrecioUnitario DECIMAL(14,5) = (SELECT TOP 1 PrecioUnitario FROM ERP.ListaPrecioDetalle WHERE IdListaPrecio = @IdListaPrecio AND IdProducto = @IdProducto)

	RETURN ISNULL(@PrecioUnitario,0)
END


