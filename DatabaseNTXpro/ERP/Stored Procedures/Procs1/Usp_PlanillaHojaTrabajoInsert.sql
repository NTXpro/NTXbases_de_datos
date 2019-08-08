CREATE PROCEDURE ERP.Usp_PlanillaHojaTrabajoInsert
	(
		@IdPlanillaCabecera [bigint],
		@IdConcepto [int],
		@HoraPorcentaje [decimal](18, 2)
	)
AS
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	BEGIN TRANSACTION

	INSERT INTO [ERP].[PlanillaHojaTrabajo]
	(
		[IdPlanillaCabecera], [IdConcepto], [HoraPorcentaje]
	)
	VALUES
	(
		@IdPlanillaCabecera,
		@IdConcepto,
		@HoraPorcentaje

	)
	SELECT [ID], [IdPlanillaCabecera], [IdConcepto], [HoraPorcentaje]
	FROM [ERP].[PlanillaHojaTrabajo]
	

	COMMIT