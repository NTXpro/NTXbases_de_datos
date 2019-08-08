CREATE PROC [ERP].[Usp_Upd_Servicio_Desactivar]
@IdProducto	INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
	UPDATE [ERP].[Producto] SET Flag = 0, FechaEliminado = DATEADD(HOUR, 3, GETDATE()),UsuarioElimino=@UsuarioElimino WHERE ID = @IdProducto AND IdTipoProducto=2
END
