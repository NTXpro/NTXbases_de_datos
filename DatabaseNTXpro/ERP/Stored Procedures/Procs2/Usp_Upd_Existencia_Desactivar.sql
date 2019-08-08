CREATE PROC [ERP].[Usp_Upd_Existencia_Desactivar]
@IdExistencia			INT,
@UsuarioElimino			VARCHAR(250)
AS
BEGIN
	UPDATE [PLE].[T5Existencia] SET Flag = 0 , FechaEliminado = DATEADD(HOUR, 3, GETDATE()), UsuarioElimino = @UsuarioElimino  WHERE ID = @IdExistencia
END

