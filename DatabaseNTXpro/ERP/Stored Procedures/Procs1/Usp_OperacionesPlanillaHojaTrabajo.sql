CREATE PROCEDURE [ERP].[Usp_OperacionesPlanillaHojaTrabajo]
	(
		@IdPlanillaCabecera [bigint],
		@IdConcepto [int],
		@HoraPorcentaje [decimal](18, 2),
		@Operacion int,  -- 0 Crear 1 Update 2 Delete
	    @Valores varchar(MAX)
	)
AS
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	BEGIN TRANSACTION
	IF @Operacion <> 2 
	BEGIN
	DECLARE @existe int = 0
	SELECT @existe = count(id) FROM ERP.PlanillaHojaTrabajo   WHERE ERP.PlanillaHojaTrabajo.IdPlanillaCabecera =@IdPlanillaCabecera AND ERP.PlanillaHojaTrabajo.IdConcepto = @IdConcepto 
	IF @existe = 0 
	BEGIN
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
	END

	IF @existe >0 
	BEGIN
	 UPDATE ERP.PlanillaHojaTrabajo
	  SET
	      ERP.PlanillaHojaTrabajo.HoraPorcentaje = @HoraPorcentaje -- decimal
		  WHERE ERP.PlanillaHojaTrabajo.IdPlanillaCabecera =@IdPlanillaCabecera AND ERP.PlanillaHojaTrabajo.IdConcepto = @IdConcepto 
	END


	END
	IF @Operacion = 2 
	BEGIN
		DECLARE @query varchar(MAX) = 'DELETE FROM ERP.PlanillaHojaTrabajo  WHERE IdPlanillaCabecera IN ('+ @valores+') AND ERP.PlanillaHojaTrabajo.IdConcepto =' +cast(@IdConcepto AS varchar(20))
		EXEC ( @query)     
	END
	COMMIT