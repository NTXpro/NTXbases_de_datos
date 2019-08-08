CREATE PROCEDURE ERP.Usp_PlanillaHojaTrabajoUpdate
	(
		@ID [bigint],
		@IdPlanillaCabecera [bigint],
		@IdConcepto [int],
		@HoraPorcentaje [decimal](18, 2)
	)
AS
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	BEGIN TRANSACTION
		UPDATE [ERP].[PlanillaHojaTrabajo]
		SET [IdPlanillaCabecera] = @IdPlanillaCabecera, [IdConcepto] = @IdConcepto, [HoraPorcentaje] = @HoraPorcentaje
		WHERE ([ID] = @ID)
	COMMIT