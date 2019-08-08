CREATE PROCEDURE Seguridad.Usp_Upd_Contrasenia_Usuario
@IdUsuario INT,
@Clave VARCHAR(50)
AS
BEGIN

	UPDATE Seguridad.Usuario SET Clave = @Clave WHERE ID = @IdUsuario

END

