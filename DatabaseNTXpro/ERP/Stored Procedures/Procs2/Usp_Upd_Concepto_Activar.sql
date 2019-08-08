CREATE PROC [ERP].[Usp_Upd_Concepto_Activar]
@ID INT,
@UsuarioActivo VARCHAR(250),
@FechaActivacion DATETIME
AS
BEGIN
	UPDATE [ERP].[Concepto] SET 
	Flag = 1,
	[UsuarioActivo] = @UsuarioActivo,
	[FechaActivacion] = @FechaActivacion
	WHERE ID = @ID
END
