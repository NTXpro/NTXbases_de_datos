CREATE PROC [Seguridad].[Usp_Upd_Acceso_Desactivar]
@IdRol INT,
@UsuarioModificoPerfil VARCHAR(250)
AS
BEGIN
	UPDATE Seguridad.Rol SET FechaModificadoPerfil = DATEADD(HOUR,3,GETDATE()), UsuarioModificoPerfil = @UsuarioModificoPerfil WHERE ID = @IdRol
	UPDATE Seguridad.PaginaRol SET Ver = 0 WHERE IdRol = @IdRol
END