
CREATE PROC ERP.Usp_Upd_TransformacionServicio_Desactivar
@IdTransformacionServicio INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
			UPDATE Maestro.TransformacionServicio	SET	UsuarioElimino = @UsuarioElimino,
													FechaEliminado = DATEADD(HOUR, 3, GETDATE()),
													Flag = 1 
													WHERE ID = @IdTransformacionServicio
END
