CREATE PROC [ERP].[Usp_Upd_Ubicacion_Desactivar]
@IdUbicacion INT,
@UsuarioElimino VARCHAR(250),
@FechaEliminado DATETIME
AS
BEGIN
	UPDATE ERP.Ubicacion SET 
	Flag = 0,
	[UsuarioElimino] = @UsuarioElimino,
	[FechaEliminado] = @FechaEliminado
	WHERE ID = @IdUbicacion
END
