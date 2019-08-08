-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 09/02/2018
-- Description:	
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Calculo_PlanillaTrabajo_TodosEmpleados]
@pFechaInicioNomina datetime,
@pFechaFinNomina datetime ,
@pidPlanilla	int ,
@pidEmpresa int

AS
BEGIN
declare @cont int = 0
DECLARE @cIdTrabajador as int
DECLARE @cIdDatoLaboralDetalle  as int
DECLARE ProdInfo CURSOR FOR select pc.IdTrabajador,pc.IdDatoLaboralDetalle from ERP.PlanillaCabecera pc where pc.FechaInicio =@pFechaInicioNomina and pc.FechaFin =@pFechaFinNomina
and pc.IdPlanilla = @pidPlanilla and pc.IdEmpresa = @pidEmpresa
OPEN ProdInfo
FETCH NEXT FROM ProdInfo INTO @cIdTrabajador,@cIdDatoLaboralDetalle
WHILE @@fetch_status = 0
BEGIN
	SET @cont = @cont + 1
    EXEC ERP.Usp_Calculo_PlanillaTrabajo_Trabajador	@pFechaInicioNomina,@pFechaFinNomina,@pidPlanilla,@pidEmpresa,@cIdTrabajador,@cIdDatoLaboralDetalle
    FETCH NEXT FROM ProdInfo INTO @cIdTrabajador,@cIdDatoLaboralDetalle
END
CLOSE ProdInfo
DEALLOCATE ProdInfo
SELECT @cont

END