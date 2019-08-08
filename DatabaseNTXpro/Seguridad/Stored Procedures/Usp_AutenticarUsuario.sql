CREATE PROC [Seguridad].[Usp_AutenticarUsuario] --'user@ntx360.net','123456'
@Correo VARCHAR(50), 
@Clave VARCHAR(20)
AS
BEGIN

	SELECT 
		U.ID AS IdUsuario, 
		P.Nombre AS NombreUsuario, 
		P.ApellidoPaterno, 
		P.ApellidoMaterno,
		V.ID AS IdVersion, 
		V.Nombre AS NombreVersion, 
		V.Abreviatura,
		U.FlagAdministrador,
		U.IdEntidad
	FROM Seguridad.Usuario U
	INNER JOIN ERP.Persona P
	ON P.IdEntidad = U.IdEntidad
	INNER JOIN ERP.Version V
	ON V.ID = U.IdVersion
	WHERE Correo = @Correo AND Clave = @Clave AND FlagBorrador = 0 AND FLAG = 1
END
