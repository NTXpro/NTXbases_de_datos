-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 12/01/2018
-- Description:	GENERA DATA PARA LAS PLANILLAS DE NOMINA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Lista_Pago_Concepto_Planilla_Nomina]
	-- Add the parameters for the stored procedure here
	@IdPlanillaCabecera int 
AS
BEGIN
     SELECT pp.ID, pp.IdPlanillaCabecera, pp.IdConcepto, pp.SueldoMinimo, pp.Calculo FROM ERP.PlanillaPago pp
	 INNER JOIN ERP.Concepto c ON pp.IdConcepto = c.ID
	 WHERE pp.IdPlanillaCabecera =@IdPlanillaCabecera
	 ORDER BY c.Orden
END