CREATE PROC [ERP].[Usp_Upd_Puesto_Desactivar]
@IdOcupacion		INT,
@UsuarioElimino			VARCHAR(250)
AS
BEGIN
	UPDATE [Maestro].[Puesto] SET Flag = 0 , UsuarioElimino = @UsuarioElimino, FechaEliminado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdOcupacion
END