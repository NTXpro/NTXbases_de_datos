CREATE PROC [ERP].[Usp_Sel_LiquidacionDetalle_By_ID]
@ID INT
AS
BEGIN
SELECT LD.ID
	,LD.IdLiquidacion
	,LD.IdDatoLaboral
	,LD.Sueldo
	,LD.CTSTrunca
	,LD.VacacionTrunca
	,LD.GratificacionTrunca
	,LD.OtroIngreso
	,LD.Descuento
	,LD.OtroDescuento
	,LD.Aportacion
	,LD.TotalLiquidacion
	,DL.FechaInicio
	,DL.FechaCese FechaFin
	,TD.Abreviatura TipoDocumentoTrabajador
	,ETD.NumeroDocumento NumeroDocumentoTrabajador
	,E.Nombre NombreTrabajador
	,DL.FechaInicio
	,DL.FechaCese FechaFin
	,P.Nombre NombrePlanilla
	,FechaInicioGratificacion
	,FechaFinGratificacion
	,AsignacionFamiliarGratificacion
	,BonificacionGratificacion
	,ComisionGratificacion
	,HE25Gratificacion
	,HE35Gratificacion
	,HE100Gratificacion
	,MesGratificacion
	,DiaGratificacion
	,FechaInicioVacacion
	,FechaFinVacacion
	,AsignacionFamiliarVacacion
	,BonificacionVacacion
	,ComisionVacacion
	,HE25Vacacion
	,HE35Vacacion
	,HE100Vacacion
	,FechaInicioCTS
	,FechaFinCTS
	,AsignacionFamiliarCTS
	,BonificacionCTS
	,ComisionCTS
	,HE25CTS
	,HE35CTS
	,HE100CTS
	,MesCTS
	,DiaCTS
FROM ERP.LiquidacionDetalle LD
INNER JOIN ERP.Liquidacion L ON LD.IdLiquidacion = L.ID
INNER JOIN ERP.Datolaboral DL ON DL.ID = LD.IdDatoLaboral
INNER JOIN ERP.Trabajador T ON T.ID = DL.IdTrabajador
INNER JOIN ERP.Entidad E ON E.ID = T.IdEntidad
INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID 
INNER JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
INNER JOIN Maestro.Planilla P ON P.ID = DL.IdPlanilla
WHERE LD.ID = @ID
END
