

create PROC [ERP].[Usp_Sel_UltimaFechaGratificacion_By_DatoLaboral]
@IdDatoLaboral INT
AS
BEGIN
	DECLARE @FechaFinGratificacion DATETIME = (SELECT TOP 1 MAX(Gratificacion.FechaFin) FROM ERP.Gratificacion Gratificacion
											INNER JOIN ERP.GratificacionDetalle GratificacionD ON GratificacionD.IdGratificacion = Gratificacion.ID
											WHERE GratificacionD.IdDatoLaboral = @IdDatoLaboral);
	SELECT @FechaFinGratificacion;
END
