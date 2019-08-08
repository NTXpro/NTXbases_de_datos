﻿CREATE PROCEDURE ERP.Usp_PlanillaHojaTrabajoPorPlanilla
		@IdPlanillaCabecera [bigint]
AS
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	BEGIN TRANSACTION

	SELECT [ID], [IdPlanillaCabecera], [IdConcepto], [HoraPorcentaje]
	FROM [ERP].[PlanillaHojaTrabajo]
	WHERE ([IdPlanillaCabecera] = @IdPlanillaCabecera)

	COMMIT