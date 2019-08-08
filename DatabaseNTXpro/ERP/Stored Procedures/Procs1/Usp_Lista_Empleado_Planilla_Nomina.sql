-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 12/01/2018
-- Description:	GENERA DATA PARA LAS PLANILLAS DE NOMINA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Lista_Empleado_Planilla_Nomina]
	-- Add the parameters for the stored procedure here
	@FechaInicioNomina datetime ,
	@FechaFinNomina datetime ,
	@idPlanilla	int ,
	@idEmpresa int ,
	@idTipoPlanilla int 
AS
BEGIN
         SELECT  ROW_NUMBER() OVER(ORDER BY p.ApellidoPaterno, p.ApellidoMaterno, p.Nombre DESC) AS RowId,
		 (SELECT top 1 pc.ID FROM ERP.PlanillaCabecera pc	WHERE pc.IdDatoLaboralDetalle= DLD.ID) AS IdPlanillaCabecera,
	   Abreviatura, NumeroDocumento, (p.ApellidoPaterno +' '+ p.ApellidoMaterno+' '+ p.Nombre) as Nombres, FechaCese,dld.FechaInicio,dld.FechaFin,dld.HoraBase,dld.Sueldo FROM  
	 ERP.DatoLaboralDetalle dld	 INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
	 AND ((DL.FechaCese <= @FechaFinNomina OR dl.FechaCese IS null) AND (dl.FechaCese>= @FechaInicioNomina  OR dl.FechaCese IS null))
     INNER JOIN ERP.Trabajador t ON dl.IdTrabajador = t.ID      INNER JOIN ERP.Persona p ON t.IdEntidad = p.IdEntidad
     INNER JOIN ERP.EntidadTipoDocumento etd ON p.IdEntidad = etd.IdEntidad  INNER JOIN PLE.T2TipoDocumento td ON etd.IdTipoDocumento = td.ID
	 INNER JOIN MAESTRO.Planilla p2 ON DLD.IdPlanilla = p2.ID 
	 WHERE 
	 dld.FechaInicio<= @FechaFinNomina 	 AND (dld.FechaFin >=@FechaInicioNomina OR dld.FechaFin IS NULL) 
	 AND dld.IdPlanilla = @idPlanilla AND DL.IdEmpresa = @idEmpresa	 AND p2.IdTipoPlanilla = @idTipoPlanilla
	 ORDER BY p.ApellidoPaterno, p.ApellidoMaterno, p.Nombre DESC

END