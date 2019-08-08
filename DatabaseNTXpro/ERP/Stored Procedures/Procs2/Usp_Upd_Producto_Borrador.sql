CREATE PROC [ERP].[Usp_Upd_Producto_Borrador]
@IdProducto	INT,
@Nombre			VARCHAR(50)
AS
BEGIN
		UPDATE [ERP].[Producto] SET Nombre= @Nombre  WHERE ID=@IdProducto AND IdTipoProducto= 1
END
