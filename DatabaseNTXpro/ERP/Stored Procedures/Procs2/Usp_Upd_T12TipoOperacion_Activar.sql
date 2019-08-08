CREATE PROC [ERP].[Usp_Upd_T12TipoOperacion_Activar]
@ID INT,
@UsuarioActivo VARCHAR(250),
@FechaActivacion DATETIME
AS
BEGIN
	UPDATE [PLE].[T12TipoOperacion] SET 
	Flag = 1,
	[UsuarioActivo] = @UsuarioActivo,
	[FechaActivacion] = @FechaActivacion
	WHERE ID = @ID
END