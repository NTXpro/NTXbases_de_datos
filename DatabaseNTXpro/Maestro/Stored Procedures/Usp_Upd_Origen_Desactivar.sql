CREATE PROC [Maestro].[Usp_Upd_Origen_Desactivar]
@ID INT,
@UsuarioElimino VARCHAR(250),
@FechaEliminado DATETIME
AS
BEGIN
	UPDATE [Maestro].[Origen] SET 
	Flag = 0,
	[UsuarioElimino] = @UsuarioElimino,
	[FechaEliminado] = @FechaEliminado
	WHERE ID = @ID
END
