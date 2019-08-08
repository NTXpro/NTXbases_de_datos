CREATE PROC [ERP].[Usp_Upd_Planilla_Activar]
@ID INT,
@UsuarioActivo VARCHAR(250),
@FechaActivacion DATETIME
AS
BEGIN
	UPDATE [Maestro].[Planilla] SET 
	[Flag] = 1,
	[UsuarioActivo] = @UsuarioActivo,
	[FechaActivacion] = @FechaActivacion
	WHERE ID = @ID
END
