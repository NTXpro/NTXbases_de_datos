CREATE PROC [ERP].[Usp_Upd_Marca_Desactivar]
@IdMarca			INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
	UPDATE Maestro.Marca SET Flag = 0 , UsuarioElimino = @UsuarioElimino, FechaEliminado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdMarca
END
