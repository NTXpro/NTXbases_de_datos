CREATE PROCEDURE [ERP].[Usp_Sel_Rol_Export]
@Flag bit
AS
BEGIN
SELECT
			RO.ID,
			RO.Nombre,
			RO.FechaRegistro,
			RO.FechaEliminado
		FROM [Seguridad].[Rol] RO
		--LEFT JOIN [Seguridad].[UsuarioRol] URO
		--ON URO.IdRol=RO.ID
		--LEFT JOIN [Seguridad].[Usuario] USU
		--ON USU.ID=URO.IdUsuario
		WHERE RO.Flag = @Flag AND RO.FlagBorrador = 0
END

