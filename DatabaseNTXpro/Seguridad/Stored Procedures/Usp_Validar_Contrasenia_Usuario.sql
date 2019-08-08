CREATE PROCEDURE Seguridad.Usp_Validar_Contrasenia_Usuario
@IdUsuario INT,
@Clave VARCHAR(50)
AS
BEGIN
	
	DECLARE @COUNT INT = (SELECT COUNT(ID) FROM Seguridad.Usuario WHERE Clave = @Clave AND ID = @IdUsuario)
	
	SELECT CAST(ISNULL(@COUNT,0) AS BIT)
END

