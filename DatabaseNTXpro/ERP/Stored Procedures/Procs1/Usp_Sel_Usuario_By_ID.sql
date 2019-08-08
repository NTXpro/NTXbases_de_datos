CREATE PROC [ERP].[Usp_Sel_Usuario_By_ID]-- 5
@ID int
AS
BEGIN

	SELECT U.ID						ID,
		   U.IdEntidad				IdEntidad,
		   U.Correo					Correo,
		   U.Clave					Clave,
		   P.Nombre					Nombre,
		   P.ApellidoPaterno		ApellidoPaterno,
		   P.ApellidoMaterno		ApellidoMaterno,
		   UR.IdRol					IdRol,
		   RO.Nombre				NombreRol,
		   U.FechaRegistro			FechaRegistro,
		   ETD.IdTipoDocumento		IdTipoDocumento,
		   ETD.NumeroDocumento		NumeroDocumento,
		   TD.Abreviatura				NombreTipoDocumento,
		   U.FechaRegistro,
		   U.FechaModificado,
		   U.FechaEliminado,
		   U.FechaActivacion,
		   U.UsuarioRegistro,
		   U.UsuarioElimino,
		   U.UsuarioModifico,
		   U.UsuarioActivo,
		   U.FlagAdministrador,
		   U.IdProyecto
	FROM Seguridad.Usuario U 
	INNER JOIN ERP.Entidad EN
		ON EN.ID = U.IdEntidad
	INNER JOIN ERP.Persona P
		ON P.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
	LEFT JOIN Seguridad.UsuarioRol UR
		ON UR.IdUsuario = U.ID
	LEFT JOIN Seguridad.Rol RO
		ON RO.ID=UR.IdRol
	WHERE U.ID = @ID

END