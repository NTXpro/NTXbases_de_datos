CREATE PROC [ERP].[Usp_Upd_Establecimiento_Desactivar]
@IdEstablecimiento			INT,
@UsuarioElimino				VARCHAR(250),
@FechaEliminado				DATETIME
AS
BEGIN
	UPDATE [ERP].[Establecimiento] SET 
	Flag = 0,
	UsuarioElimino = @UsuarioElimino,
	FechaEliminado = @FechaEliminado
	WHERE ID = @IdEstablecimiento
END
