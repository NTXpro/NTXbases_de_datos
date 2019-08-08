CREATE PROC [ERP].[Usp_Upd_Trabajador_Desactivar]
@ID INT,
@UsuarioElimino VARCHAR(250),
@FechaEliminado DATETIME
AS
BEGIN
	UPDATE [ERP].[Trabajador] SET 
	Flag = 0,
	[UsuarioElimino] = @UsuarioElimino,
	[FechaEliminado] = @FechaEliminado
	WHERE ID = @ID
END
