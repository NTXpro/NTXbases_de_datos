-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 12/01/2018
-- Description:	GENERA DATA PARA LAS PLANILLAS DE NOMINA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Lista_Nombre_Concepto_Planilla_Nomina]
	@FechaInicioNomina datetime ,
	@FechaFinNomina datetime ,
	@idPlanilla	int ,
	@idEmpresa int ,
	@idTipoPlanilla int 

AS
BEGIN

	 SELECT DISTINCT c.Nombre, c.Orden FROM ERP.PlanillaPago pp
	 INNER JOIN  ERP.PlanillaCabecera pc ON pp.IdPlanillaCabecera = pc.ID
	 INNER JOIN  erp.Concepto c ON pp.IdConcepto = c.ID
	 INNER JOIN
     (SELECT  dld.ID  FROM ERP.DatoLaboralDetalle dld	 INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
	 AND ((DL.FechaCese <= @FechaFinNomina OR dl.FechaCese IS null) AND (dl.FechaCese>= @FechaInicioNomina  OR dl.FechaCese IS null))
	 INNER JOIN MAESTRO.Planilla p2 ON DLD.IdPlanilla = p2.ID 	 
	 WHERE 
	 dld.FechaInicio<= @FechaFinNomina 	 AND (dld.FechaFin >=@FechaInicioNomina OR dld.FechaFin IS NULL) 
	 AND dld.IdPlanilla = @idPlanilla AND DL.IdEmpresa = @idEmpresa	 ) A  ON a.ID = pc.IdDatoLaboralDetalle
	 ORDER BY c.Orden
END