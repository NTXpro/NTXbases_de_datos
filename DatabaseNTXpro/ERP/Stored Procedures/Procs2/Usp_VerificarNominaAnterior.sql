


-----------
-- Stored Procedure

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ERP].[Usp_VerificarNominaAnterior] 
@fechaInicioP datetime ,
@IdPlanilla int,
@IdEmpresa  int 
AS
BEGIN
DECLARE @DiasResta int 
DECLARE @Primero int = 0


DECLARE @NominaAnteriorUltimoDia datetime  =dateadd(day,-1, @fechaInicioP)
IF not EXISTS(SELECT TOP 1 * FROM ERP.PlanillaCabecera pc WHERE pc.FechaFin < @NominaAnteriorUltimoDia AND pc.IdPlanilla = @IdPlanilla) 
BEGIN
set @Primero = 1
END
SELECT  count(pc.id) +@Primero  AS existe FROM ERP.PlanillaCabecera pc WHERE pc.FechaFin = @NominaAnteriorUltimoDia AND pc.IdPlanilla = @IdPlanilla AND pc.IdEmpresa = @IdEmpresa
END