CREATE PROC [ERP].[Usp_Upd_Usuario_Desactivar]
@IdUsuario INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN

	UPDATE Seguridad.Usuario SET Flag = 0, UsuarioElimino = @UsuarioElimino ,FechaEliminado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdUsuario
	
END