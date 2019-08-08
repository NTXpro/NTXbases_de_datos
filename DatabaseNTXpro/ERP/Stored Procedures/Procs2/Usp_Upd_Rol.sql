CREATE PROC [ERP].[Usp_Upd_Rol]
@IdRol  INT,
@Nombre  VARCHAR(50),
@FlagBorrador BIT,
@UsuarioModifico	VARCHAR(250)
AS
BEGIN
	
	UPDATE [Seguridad].[Rol] SET
								Nombre=@Nombre,
								FlagBorrador=@FlagBorrador,
								UsuarioModifico=@UsuarioModifico,
								FechaModificado=DATEADD(HOUR, 3, GETDATE())
	WHERE ID = @IdRol 
END
