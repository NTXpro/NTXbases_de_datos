CREATE PROC [ERP].[Usp_Upd_Planilla_Desactivar]
@ID INT,
@UsuarioElimino VARCHAR(250),
@FechaEliminado DATETIME
AS
BEGIN
	UPDATE [Maestro].[Planilla] SET 
	[Flag] = 0,
	[UsuarioElimino] = @UsuarioElimino,
	[FechaEliminado] = @FechaEliminado
	WHERE ID = @ID
END
