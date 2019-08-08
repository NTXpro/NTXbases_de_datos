
CREATE PROC ERP.Usp_Del_TransformacionServicio
@IdTransformacionServicio INT
AS
BEGIN
		DELETE Maestro.TransformacionServicio WHERE ID = @IdTransformacionServicio
END
