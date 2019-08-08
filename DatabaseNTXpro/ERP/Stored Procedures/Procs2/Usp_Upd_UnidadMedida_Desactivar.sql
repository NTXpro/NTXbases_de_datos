
CREATE PROC [ERP].[Usp_Upd_UnidadMedida_Desactivar]
@IdUnidadMedida			INT,
@UsuarioElimino			VARCHAR(250)
AS
BEGIN
	UPDATE [PLE].[T6UnidadMedida] SET Flag = 0 , UsuarioElimino = @UsuarioElimino, FechaEliminado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdUnidadMedida
END
