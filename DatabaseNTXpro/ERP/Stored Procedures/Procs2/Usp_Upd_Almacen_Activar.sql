
CREATE PROC [ERP].[Usp_Upd_Almacen_Activar]
@IdAlmacen			INT,
@UsuarioActivo		VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Almacen SET Flag = 1 ,FechaActivacion = DATEADD(HOUR, 3, GETDATE()) ,UsuarioActivo=@UsuarioActivo WHERE ID = @IdAlmacen
END
