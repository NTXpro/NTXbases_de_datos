
CREATE FUNCTION [ERP].[ObtenerGratificacionDatoLaboralByFecha](
@IdDatoLaboral INT,
@FechaInicio DATETIME,
@FechaFin DATETIME
)
RETURNS DECIMAL(14,5)
AS
BEGIN
		DECLARE @TotalGratificacion DECIMAL(15,2) = (SELECT TOP 1 GD.TotalGratificacion 
									 FROM ERP.Gratificacion G
									 INNER JOIN ERP.GratificacionDetalle GD ON GD.IdGratificacion = G.ID 
									 WHERE GD.IdDatoLaboral = @IdDatoLaboral
									 AND CAST(FechaInicio AS DATE) >= CAST(@FechaInicio AS DATE) 
									 AND CAST(FechaFin AS DATE) <= CAST(@FechaFin AS DATE))
		RETURN ISNULL(@TotalGratificacion, 0)
END
