CREATE PROC [ERP].[Usp_Sel_Rol_Borrador_Pagination]
AS
BEGIN

	SELECT	--TOP 20 
			RO.ID,
			RO.Nombre,
			RO.FechaRegistro
	FROM [Seguridad].[Rol] RO
	LEFT JOIN [Seguridad].[UsuarioRol] URO
	ON URO.IdRol=RO.ID
	LEFT JOIN [Seguridad].[Usuario] USU
	ON USU.ID=URO.IdUsuario
	WHERE RO.FlagBorrador = 1
END
