-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 09/02/2018
-- Description:	
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Sel_Calculo_PlanillaTrabajo_TodosEmpleados]
@pFechaInicioNomina datetime,
@pFechaFinNomina datetime ,
@pidPlanilla	int ,
@pidEmpresa int

AS
BEGIN
select pc.IdTrabajador,pc.IdDatoLaboralDetalle from ERP.PlanillaCabecera pc where pc.FechaInicio =@pFechaInicioNomina and pc.FechaFin =@pFechaFinNomina
and pc.IdPlanilla = @pidPlanilla and pc.IdEmpresa = @pidEmpresa

--EXEC ERP.Usp_Calculo_PlanillaTrabajo_Trabajador	@pFechaInicioNomina,@pFechaFinNomina,@pidPlanilla,@pidEmpresa,@cIdTrabajador,@cIdDatoLaboralDetalle


END