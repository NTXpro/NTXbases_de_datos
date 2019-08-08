CREATE PROC [ERP].[Usp_Upd_Servicio_Activar]
@IdProducto			INT,
@UsuarioActivo		VARCHAR(250)
AS
BEGIN
	UPDATE [ERP].[Producto] SET Flag = 1, FechaActivacion = DATEADD(HOUR, 3, GETDATE()) ,UsuarioActivo=@UsuarioActivo WHERE ID = @IdProducto AND IdTipoProducto=2
END

