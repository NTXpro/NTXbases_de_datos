

CREATE PROC [ERP].[Usp_Del_Usuario]
@IdUsuario INT
AS
BEGIN
	
	DELETE FROM Seguridad.UsuarioRol WHERE IdUsuario =  @IdUsuario
	DELETE FROM Seguridad.Usuario WHERE ID = @IdUsuario

END

