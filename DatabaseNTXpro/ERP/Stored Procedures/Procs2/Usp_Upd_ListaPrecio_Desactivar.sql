CREATE PROC [ERP].[Usp_Upd_ListaPrecio_Desactivar]
@ID INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
	UPDATE ERP.ListaPrecio SET FLAG = 0, FechaEliminado = DATEADD(HOUR, 3, GETDATE()), UsuarioElimino = @UsuarioElimino WHERE ID = @ID
END