-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 27-06-2019
-- Description:	ACTUALIZAR EXCEL
-- =============================================
CREATE PROCEDURE ERP.usp_carga_masiva_concepto_excel
   @NumeroDocumento nvarchar(20) ,
   @FechaInicio datetime,
   @FechaFin datetime ,
   @idPlanilla	int,
   @idEmpresa int ,
   @IdConcepto int ,
   @Valor decimal(15,5) 
AS
BEGIN
	DECLARE  @idPlanillaCabecera int=0
	DECLARE @idTrabajador int =0
	DECLARE @datolaboral int = 0 


	SELECT TOP 1 @idTrabajador = t.ID FROM ERP.Trabajador t
	INNER JOIN ERP.Entidad e ON t.IdEntidad = e.ID
	INNER JOIN ERP.EntidadTipoDocumento etd ON e.ID = etd.IdEntidad
	INNER JOIN ERP.PlanillaCabecera pc ON t.ID = pc.IdTrabajador
	WHERE etd.NumeroDocumento =@NumeroDocumento 


	SELECT @idPlanillaCabecera = pc.ID FROM ERP.PlanillaCabecera pc  WHERE pc.IdPlanilla = @idPlanilla AND pc.IdEmpresa = @idEmpresa 
						AND pc.IdTrabajador = @idTrabajador AND pc.fechainiplanilla = @FechaInicio AND pc.fechafinplanilla =@FechaFin

	IF EXISTS (SELECT pht.ID FROM ERP.PlanillaHojaTrabajo pht WHERE pht.IdPlanillaCabecera = @idPlanillaCabecera AND pht.IdConcepto =@IdConcepto )
	BEGIN
				UPDATE ERP.PlanillaHojaTrabajo
			   SET
				   IdConcepto = @IdConcepto,
				   HoraPorcentaje = @Valor
				   WHERE IdPlanillaCabecera = @idPlanillaCabecera AND IdConcepto =@IdConcepto
	END
	ELSE
	BEGIN
					INSERT ERP.PlanillaHojaTrabajo
								(IdPlanillaCabecera,IdConcepto,HoraPorcentaje)
								VALUES
								(@idPlanillaCabecera,@IdConcepto,@Valor)
	END
END