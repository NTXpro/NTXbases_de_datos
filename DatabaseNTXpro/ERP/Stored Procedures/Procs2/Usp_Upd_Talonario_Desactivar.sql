
CREATE PROC [ERP].[Usp_Upd_Talonario_Desactivar]
@IdTalonario INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
	
	UPDATE ERP.Talonario SET UsuarioElimino = @UsuarioElimino, Flag = 0, FechaEliminado = DATEADD(HOUR,3,GETDATE()) 
	WHERE ID = @IdTalonario

END