-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 12/01/2018
-- Description:	GENERA DATA PARA LAS PLANILLAS DE NOMINA
-- =============================================
CREATE PROCEDURE Usp_Generar_Datos_Planilla_Nomina
	-- Add the parameters for the stored procedure here
	@FechaInicioNomina datetime ,
	@FechaFinNomina datetime ,
	@idPlanilla	int ,
	@idEmpresa int ,
	@idTipoPlanilla int ,
	@idPeriodo int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
    -- Insert statements for procedure here
	DECLARE @pIdTrabajador AS int;
	DECLARE @pIdDatoLaboralDetalle AS int;
	DECLARE @pFechaInicio AS datetime;
	DECLARE @pFechaFin AS datetime;
	DECLARE EmpCursor CURSOR
	FOR SELECT  DL.IdTrabajador,dld.ID, dld.FechaInicio,dld.FechaFin  FROM ERP.DatoLaboralDetalle dld	 INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
	 AND ((DL.FechaCese <= @FechaFinNomina OR dl.FechaCese IS null) AND (dl.FechaCese>= @FechaInicioNomina  OR dl.FechaCese IS null))
     INNER JOIN ERP.Trabajador t ON dl.IdTrabajador = t.ID      INNER JOIN ERP.Persona p ON t.IdEntidad = p.IdEntidad
     INNER JOIN ERP.EntidadTipoDocumento etd ON p.IdEntidad = etd.IdEntidad  INNER JOIN PLE.T2TipoDocumento td ON etd.IdTipoDocumento = td.ID
	 INNER JOIN MAESTRO.Planilla p2 ON DLD.IdPlanilla = p2.ID WHERE 
	 dld.FechaInicio<= @FechaFinNomina 	 AND (dld.FechaFin >=@FechaInicioNomina OR dld.FechaFin IS NULL) 
	 AND dld.IdPlanilla = @idPlanilla AND DL.IdEmpresa = @idEmpresa	 AND p2.IdTipoPlanilla = @idTipoPlanilla

	OPEN EmpCursor;
	FETCH NEXT FROM EmpCursor INTO @pIdTrabajador,@pIdDatoLaboralDetalle,@pFechaInicio,@pFechaFin
	WHILE @@fetch_status = 0
	BEGIN
		BEGIN TRY
			    -- VERIFICAR SI EXISTE O NO EN PLANILLA CABECERA Y HACER INSERT
				DECLARE @pIdCabecera int =0
				INSERT INTO ERP.PlanillaCabecera WITH (ROWLOCK)
				(IdEmpresa,IdPeriodo,IdPlanilla,IdTrabajador,FechaInicio,FechaFin,	Orden,CodigoProceso,TotalIngreso,TotalDescuentos, TotalAportes, NetoAPagar,IdDatoLaboralDetalle)
				SELECT @idEmpresa, @idPeriodo, @idPlanilla,@pIdTrabajador,@FechaInicioNomina,@FechaFinNomina, 1,'COD',0,0,0,0,@pIdDatoLaboralDetalle
				WHERE NOT EXISTS (SELECT pc.ID FROM ERP.PlanillaCabecera pc WHERE pc.IdEmpresa = @idEmpresa AND pc.IdPeriodo = @idPeriodo AND pc.IdPlanilla= @idPlanilla
																				   AND pc.FechaFinPlanilla =@FechaFinNomina AND pc.FechaIniPlanilla = @FechaInicioNomina
																				   AND pc.FechaFin =@FechaFinNomina AND pc.FechaInicio = @FechaInicioNomina
																				  AND @pIdTrabajador =pc.IdTrabajador AND pc.IdDatoLaboralDetalle =@pIdDatoLaboralDetalle )
				-- INSERTAR VALORES EN LA TABLA PLANILLAHOJA TRABAJO
				SELECT @pIdCabecera = SCOPE_IDENTITY()
				INSERT INTO ERP.PlanillaHojaTrabajo WITH(ROWLOCK) (IdPlanillaCabecera,IdConcepto, HoraPorcentaje)
				SELECT @pIdCabecera,c.ID, c.PorDefecto FROM ERP.Concepto c WHERE c.FlagSiemprePlanilla = 1
				AND NOT EXISTS(SELECT pht.ID FROM ERP.PlanillaHojaTrabajo pht WHERE pht.IdPlanillaCabecera=@pIdCabecera) ORDER BY c.Orden
				
				-- CALCULAR VALORES DE REMUNERACION POR PRIMERA VEZ SOLAMENTE
				IF @pIdCabecera >0
				BEGIN
					SELECT DATEDIFF(day,RangoIni,RangoFin )+1 AS dias FROM 
						(
						SELECT CASE WHEN @pFechaFin  IS NULL THEN @FechaFinNomina ELSE @pFechaFin END as RangoFin,
						CASE WHEN @pFechaInicio < @FechaInicioNomina THEN @FechaInicioNomina ELSE @pFechaInicio END as RangoIni
						) AS A
				END
		END TRY
		BEGIN CATCH 
		      ROLLBACK TRANSACTION
			  SELECT  ERROR_NUMBER() AS resultado ;     
		END CATCH 
			FETCH NEXT FROM EmpCursor INTO @pIdTrabajador,@pIdDatoLaboralDetalle,@pFechaInicio,@pFechaFin
	END;
	CLOSE EmpCursor
	DEALLOCATE EmpCursor;
	SELECT  0 AS resultado
END