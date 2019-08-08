CREATE PROC [ERP].[Usp_Upd_Establecimiento_Activar]
@IdEstablecimiento			INT,
@UsuarioActivo				VARCHAR(250),
@FechaActivacion			DATETIME
AS
BEGIN

	UPDATE [ERP].[Establecimiento] SET 
	Flag = 1,
	[UsuarioActivo] = @UsuarioActivo,
	[FechaActivacion] = @FechaActivacion
	WHERE ID = @IdEstablecimiento

END
