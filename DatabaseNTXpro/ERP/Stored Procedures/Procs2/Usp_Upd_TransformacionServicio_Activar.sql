
CREATE PROC ERP.Usp_Upd_TransformacionServicio_Activar
@IdTransformacionServicio INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
			UPDATE Maestro.TransformacionServicio	SET	UsuarioActivo = @UsuarioActivo,
													FechaActivacion = DATEADD(HOUR, 3, GETDATE()),
													Flag = 1
													WHERE ID = @IdTransformacionServicio
END
