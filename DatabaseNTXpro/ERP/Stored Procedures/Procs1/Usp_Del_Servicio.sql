
CREATE PROC [ERP].[Usp_Del_Servicio]
@IdProducto INT
AS
BEGIN
		DELETE FROM ERP.ListaPrecioDetalle WHERE IdProducto = @IdProducto
		DELETE FROM [ERP].[Producto] WHERE ID=@IdProducto AND IdTipoProducto =2
END
