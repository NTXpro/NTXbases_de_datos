CREATE PROC [ERP].[Usp_Upd_T12TipoOperacion_Desactivar]
@ID INT,
@UsuarioElimino VARCHAR(250),
@FechaEliminado DATETIME
AS
BEGIN
	UPDATE [PLE].[T12TipoOperacion] SET 
	Flag = 0,
	[UsuarioElimino] = @UsuarioElimino,
	[FechaEliminado] = @FechaEliminado
	WHERE ID = @ID
END
