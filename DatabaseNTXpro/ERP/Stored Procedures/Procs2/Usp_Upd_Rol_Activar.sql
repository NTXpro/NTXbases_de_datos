
CREATE PROC [ERP].[Usp_Upd_Rol_Activar]
@IdRol		INT,
@UsuarioActivo	VARCHAR(250)
AS
BEGIN
	UPDATE [Seguridad].[Rol] SET Flag = 1, FechaActivado = DATEADD(HOUR, 3, GETDATE()) ,UsuarioActivo=@UsuarioActivo WHERE ID = @IdRol
END
