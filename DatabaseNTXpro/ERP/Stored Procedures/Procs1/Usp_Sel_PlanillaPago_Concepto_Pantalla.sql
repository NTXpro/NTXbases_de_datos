
CREATE PROCEDURE [ERP].[Usp_Sel_PlanillaPago_Concepto_Pantalla]
@FechaInicioNomina datetime, 
@FechaFinNomina datetime ,
@idPlanilla	int,
@idEmpresa int ,
@IdTrabajador int ,
@IdDatoLaboralDetalle int
AS
BEGIN

	SELECT  pp.IdConcepto,c.IdTipoConcepto, isnull(c.Orden, 0) AS Orden, isnull(c.Nombre,'N/A') AS Nombre , pp.Calculo
	  FROM ERP.DatoLaboralDetalle dld	
	  INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
	  AND ((DL.FechaCese >= @FechaInicioNomina OR dl.FechaCese IS null) )
	 INNER JOIN ERP.PlanillaCabecera pc ON pc.IdDatoLaboralDetalle = dld.ID
	 INNER JOIN erp.PlanillaPago pp ON pc.ID = pp.IdPlanillaCabecera
    	 INNER JOIN MAESTRO.Planilla p2 ON DLD.IdPlanilla = p2.ID 
	 INNER JOIN  erp.Concepto c ON pp.IdConcepto = c.ID	 
	 WHERE 
	 (pc.FechaIniPlanilla= @FechaInicioNomina AND pc.FechaFinPlanilla= @FechaFinNomina)
	 AND 
	  dld.IdPlanilla = @idPlanilla AND DL.IdEmpresa = @idEmpresa	
	 AND dl.IdTrabajador = @IdTrabajador
	 AND dld.id =@IdDatoLaboralDetalle
	  ORDER BY c.Orden

END