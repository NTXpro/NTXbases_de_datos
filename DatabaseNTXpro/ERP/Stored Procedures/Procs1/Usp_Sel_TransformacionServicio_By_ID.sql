
CREATE PROC ERP.Usp_Sel_TransformacionServicio_By_ID
@IdTransformacionServicio INT
AS
BEGIN
			SELECT * 
			FROM Maestro.TransformacionServicio WHERE ID = @IdTransformacionServicio
END
