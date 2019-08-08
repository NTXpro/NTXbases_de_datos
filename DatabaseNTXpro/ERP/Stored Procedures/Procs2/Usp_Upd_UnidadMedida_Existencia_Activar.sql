
CREATE PROC [ERP].[Usp_Upd_UnidadMedida_Existencia_Activar]
@IdExistencia		INT
AS
BEGIN
	UPDATE [PLE].[T5Existencia] SET Flag = 1 ,FechaEliminado = NULL WHERE ID = @IdExistencia
END
