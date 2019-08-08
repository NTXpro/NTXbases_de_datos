CREATE PROC [ERP].[Usp_Upd_Propiedad_Desactivar]
@IdPropiedad		INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
	UPDATE [Maestro].[Propiedad] SET Flag = 0, FechaEliminado = DATEADD(HOUR, 3, GETDATE()) , UsuarioElimino=@UsuarioElimino WHERE ID = @IdPropiedad
END
