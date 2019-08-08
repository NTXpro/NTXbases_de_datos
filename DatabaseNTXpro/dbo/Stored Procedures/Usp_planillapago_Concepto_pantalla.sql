-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 09/01/2019
-- Description:	LISTAR A 
-- =============================================
CREATE PROCEDURE Usp_planillapago_Concepto_pantalla
	@IdPlanillaCabecera  int null
AS
BEGIN
	SELECT pp.IdPlanillaCabecera, isnull(c.Nombre, 'N/A') AS Nombre, c.Orden FROM ERP.PlanillaPago pp
 INNER JOIN ERP.Concepto c ON pp.IdConcepto = c.ID 
WHERE pp.IdPlanillaCabecera = @IdPlanillaCabecera
	  ORDER BY pp.IdPlanillaCabecera, c.Orden

END