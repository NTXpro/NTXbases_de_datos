
CREATE PROCEDURE [ERP].[Usp_Sel_ImportacionServicioDetalle_By_IdImportacion]
@IdImportacion INT
AS
BEGIN
	SELECT
		TSD.ID,
		TSD.IdImportacion,
		TSD.IdImportacionServicio,
		TSD.TipoCambio,
		TSD.Soles,
		TSD.Dolares,
		TS.Nombre AS NombreImportacionServicio
	FROM [ERP].[ImportacionServicioDetalle] TSD
	LEFT JOIN Maestro.ImportacionServicio TS ON TSD.IdImportacionServicio = TS.ID
	WHERE TSD.IdImportacion = @IdImportacion
END