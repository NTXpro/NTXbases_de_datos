
CREATE PROCEDURE [Seguridad].[Usp_Sel_Usuario_By_Correo]
@Correo VARCHAR(50)
AS
BEGIN
	SELECT	U.ID, 
			P.Nombre, 
			P.ApellidoPaterno, 
			P.ApellidoMaterno, 
			Clave
	FROM Seguridad.Usuario U INNER JOIN ERP.Entidad E
		ON E.ID = U.IdEntidad
	INNER JOIN ERP.Persona P
		ON P.IdEntidad = E.ID
	WHERE U.Correo = @Correo
END

