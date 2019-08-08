CREATE PROC [ERP].[Usp_Upd_Rol_Desactivar]
@IdRol	INT,
@UsuarioElimino	VARCHAR(250)
AS
BEGIN
	UPDATE [Seguridad].[Rol] SET Flag = 0, FechaEliminado = DATEADD(HOUR, 3, GETDATE()) ,UsuarioElimino=@UsuarioElimino WHERE ID = @IdRol
END
