
CREATE PROCEDURE [ERP].[Usp_Sel_TransformacionServicioDetalle_By_IdTransformacion]
@IdTransformacion INT
AS
BEGIN
	SELECT
		TSD.ID,
		TSD.IdTransformacion,
		TSD.IdTransformacionServicio,
		TSD.Cantidad,
		TSD.PrecioUnitario,
		TSD.Total,
		TS.Nombre AS NombreTransformacionServicio
	FROM [ERP].[TransformacionServicioDetalle] TSD
	LEFT JOIN Maestro.TransformacionServicio TS ON TSD.IdTransformacionServicio = TS.ID
	WHERE TSD.IdTransformacion = @IdTransformacion
END
