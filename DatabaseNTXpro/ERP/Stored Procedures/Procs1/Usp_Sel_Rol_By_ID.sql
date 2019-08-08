CREATE PROC [ERP].[Usp_Sel_Rol_By_ID]
@ID int
AS
BEGIN

	SELECT	RO.ID											ID,
			URO.ID											IdUsuarioRol,
			USU.ID											IdUsuario,
			RO.Nombre										Nombre,
			RO.UsuarioRegistro,
			RO.UsuarioModifico,
			RO.UsuarioElimino,
			RO.UsuarioActivo,
			RO.FechaRegistro,
			RO.FechaModificado,
			RO.FechaEliminado,
			RO.FechaActivado,
			RO.FechaModificadoPerfil,
			RO.UsuarioModificoPerfil
	FROM [Seguridad].[Rol] RO
	LEFT JOIN [Seguridad].[UsuarioRol] URO
	ON URO.IdRol=RO.ID
	LEFT JOIN [Seguridad].[Usuario] USU
	ON USU.ID=URO.IdUsuario
	WHERE RO.ID = @ID
END
