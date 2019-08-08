
CREATE PROC [ERP].[Usp_Upd_Almacen_Desactivar]
@IdAlmacen			INT,
@UsuarioElimino		VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Almacen SET Flag = 0 ,FechaEliminado = DATEADD(HOUR, 3, GETDATE()),UsuarioElimino=@UsuarioElimino WHERE ID = @IdAlmacen
END
