CREATE PROC Seguridad.Usp_Ins_Rol_Usuario
@IdRol		INT,
@IdUsuario	INT
AS
BEGIN

	INSERT INTO Seguridad.UsuarioRol (IdUsuario,IdRol) VALUES (@IdUsuario,@IdRol)
END