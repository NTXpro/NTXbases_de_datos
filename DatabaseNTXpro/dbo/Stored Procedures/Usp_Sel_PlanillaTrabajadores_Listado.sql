-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Usp_Sel_PlanillaTrabajadores_Listado
	@IdEmpresa int
AS
BEGIN
	SELECT DISTINCT 
       pc.IdEmpresa, 
       pc.IdPeriodo, 
       pc.IdPlanilla, 
       p.Nombre, 
       tp.Nombre, 
       pc.FechaInicio, 
       pc.FechaFin,
	   pc.TotalIngreso,
	    pc.TotalDescuentos,
		 pc.TotalAportes,
		  pc.NetoAPagar

FROM ERP.PlanillaCabecera pc
     LEFT JOIN MAESTRO.planilla p ON pc.IdPlanilla = p.id
     LEFT JOIN Maestro.TipoPlanilla tp ON tp.Id = p.IdTipoPlanilla
WHERE pc.IdEmpresa = @IdEmpresa

END