

----

-- Stored Procedure

-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 09/02/2018
-- Description:	
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Calculo_PlanillaTrabajo_Trabajador]
@FechaInicioNomina datetime,
@FechaFinNomina datetime ,
@idPlanilla	int ,
@idEmpresa int, 
@IdTrabajador int, 
@IdDatoLaboralDetalle int
AS
BEGIN

--DECLARE  @FechaInicioNomina datetime = '2019-01-01T00:00:00'
--DECLARE  @FechaFinNomina datetime ='2019-01-31T00:00:00'
--DECLARE  @idPlanilla	int = 1
--DECLARE	 @idEmpresa int = 1
--DECLARE	 @IdTrabajador int = 3
--DECLARE	 @IdDatoLaboralDetalle int = 3
-- FUENTES ASCII www.network-science.de/ascii/ <--CYBERMEDIUM
			---------------------------------------------------------------------------------------------------------------------------------
		--	        _  ___       _      _  __ 
		--\  / /\  |_)  |   /\  |_) |  |_ (_  
		-- \/ /--\ | \ _|_ /--\ |_) |_ |_ __) 
		--------------------------------------------------------------------------------------------------------------------------------		

		DECLARE @IdPlanillaCabecera  int 
		SET @IdPlanillaCabecera = (SELECT pc.ID FROM ERP.PlanillaCabecera pc WHERE pc.IdTrabajador = @IdTrabajador AND pc.IdDatoLaboralDetalle = @IdDatoLaboralDetalle
									 AND pc.FechaIniPlanilla =@FechaInicioNomina AND pc.FechaFinPlanilla =@FechaFinNomina )
		DECLARE @IdatoLaboral  int 
		SET @IdatoLaboral = (SELECT dld.IdDatoLaboral FROM ERP.DatoLaboralDetalle dld WHERE dld.ID = @IdDatoLaboralDetalle )
		DECLARE @NombreConcepto varchar(200)

		DECLARE @RegimenLaboral int
		SET @RegimenLaboral = (SELECT dld.IdRegimenLaboral FROM ERP.DatoLaboralDetalle dld WHERE dld.ID = @IdDatoLaboralDetalle) 
		 --------------------------------------------------------------------------------------------------------------------------------		
		 -- _      _ ___ _   _     _          _         _     _  _  _          
		 --|_ /\  /   | / \ |_)   /   /\  |  /  | | |  / \   |_ |_ /  |_|  /\  
		 --| /--\ \_  | \_/ | \   \_ /--\ |_ \_ |_| |_ \_/   |  |_ \_ | | /--\ 
		  --------------------------------------------------------------------------------------------------------------------------------                                                                   

		DECLARE  @mesFactor  int = 0
		DECLARE  @anioFactor int =0
		DECLARE  @anioIDFactor int = 0

		SELECT @mesFactor = month(FF.fechatrabajo), @anioFactor= year(FF.fechatrabajo) FROM 
		(SELECT CASE WHEN 
				datediff( day, @FechaInicioNomina, cast((cast(year(@FechaInicioNomina) AS varchar(10))+ '-'  + cast(month(@FechaInicioNomina) AS varchar(20))+ '-' + cast(day(EOMONTH(@FechaInicioNomina)) AS varchar(20))) AS datetime))<
				datediff( day, cast((cast(year((@FechaFinNomina)) AS varchar(10))+ '-'  + cast(month(@FechaFinNomina) AS varchar(20))+ '-01') AS datetime), @FechaFinNomina )
				THEN @FechaFinNomina 
				ELSE @FechaInicioNomina 
				END AS fechatrabajo) FF

		SELECT @anioIDFactor = a.ID FROM Maestro.Anio a  WHERE a.Nombre = cast(@anioFactor as varchar(50))
		--------------------------------------------------------------------------------------------------------------------------------
	    --      __ ___  __            _ ___  _          _          ___    ___       _  
        -- /\  (_   |  /__ |\ |  /\  /   |  / \ |\ |   |_ /\  |\/|  |  |   |   /\  |_) 
        --/--\ __) _|_ \_| | \| /--\ \_ _|_ \_/ | \|   | /--\ |  | _|_ |_ _|_ /--\ | \                                                                             
		--------------------------------------------------------------------------------------------------------------------------------
		DECLARE @HoraBaseTipoPlanilla int = 1  
		DECLARE @familia int =0
		DECLARE @factorfamilia decimal(18,6) =1
		DECLARE @MinimoSueldo decimal(18,6) =0
		DECLARE @PorcentajeFamilia decimal(18,6) =0
		DECLARE @asignacionfamiliar decimal(18,6) =0
		DECLARE @asignacionfamiliarHora decimal(18,6) =0
		SELECT @familia =count(tf.ID) FROM ERP.TrabajadorFamilia tf
				WHERE  tf.FechaDeAlta<= @FechaFinNomina  AND (tf.FechaBaja >=@FechaInicioNomina OR tf.FechaBaja IS NULL)   AND tf.IdTrabajador = @IdTrabajador 
				AND (SELECT dl.FlagAsignacionFamiliar FROM ERP.DatoLaboralDetalle dld INNER JOIN ERP.DatoLaboral dl ON dld.IdDatoLaboral = dl.ID WHERE DLD.ID = @idDatoLaboralDetalle) = 1
		SELECT @MinimoSueldo= cast(p.Valor as decimal(18,6))  FROM ERP.Parametro p WHERE p.Abreviatura ='RRHHSM'

		SELECT @HoraBaseTipoPlanilla= dld.HoraBase FROM ERP.DatoLaboralDetalle dld	 INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
			INNER JOIN ERP.PlanillaCabecera pc ON pc.IdDatoLaboralDetalle = dld.ID
			INNER JOIN ERP.Trabajador t ON dl.IdTrabajador = t.ID      INNER JOIN ERP.Persona p ON t.IdEntidad = p.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento etd ON p.IdEntidad = etd.IdEntidad  INNER JOIN PLE.T2TipoDocumento td ON etd.IdTipoDocumento = td.ID	
		WHERE 
			dld.FechaInicio<= @FechaFinNomina 	 AND (dld.FechaFin >=@FechaInicioNomina OR dld.FechaFin IS NULL) 
			AND dld.IdPlanilla = @idPlanilla AND DL.IdEmpresa = @idEmpresa	
			AND dl.IdTrabajador = @IdTrabajador

		--SELECT  @HoraBaseTipoPlanilla =  CASE 
		--											WHEN p.IdTipoPlanilla = 1 THEN  240 
		--											WHEN p.IdTipoPlanilla = 2 THEN  12 
		--											WHEN p.IdTipoPlanilla = 3 THEN  48  END  from Maestro.Planilla p WHERE p.id =@idPlanilla
		IF (SELECT dl.FlagAsignacionFamiliar FROM ERP.DatoLaboralDetalle dld INNER JOIN ERP.DatoLaboral dl ON dld.IdDatoLaboral = dl.ID WHERE DLD.ID = @idDatoLaboralDetalle) = 1
		BEGIN
		  SET @factorfamilia = 10 -- pendiente
		  SET @familia = 1
		  SELECT @asignacionfamiliarHora = (@MinimoSueldo)/@HoraBaseTipoPlanilla
		  SELECT  @asignacionfamiliar =   (@asignacionfamiliarHora*@HoraBaseTipoPlanilla)/@factorfamilia
		END 
		DECLARE @HorasEfectivasX decimal(18,6)=0
		DECLARE @HorasEfectivasXY decimal(18,6)=0
		SELECT @HorasEfectivasX= pht.HoraPorcentaje  FROM ERP.PlanillaHojaTrabajo pht WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND pht.IdConcepto =1	
		SELECT @HorasEfectivasXY= pht.HoraPorcentaje  FROM ERP.PlanillaHojaTrabajo pht WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND pht.IdConcepto =29
		IF ((@HorasEfectivasX+@HorasEfectivasXY) =0)
		BEGIN
		 SET @asignacionfamiliar = 0
		END     
			IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 2 AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
			BEGIN
			    UPDATE ERP.PlanillaPago
			    SET
			        ERP.PlanillaPago.Calculo = @asignacionfamiliar 
				    WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 2
			END
			ELSE
			BEGIN
			  INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,2,0, @asignacionfamiliar)
			END




		---------------------------------------------------------------------------------------------------------------------------------
		-- __      _     _   _              _   _       
		--(_  | | |_ |  | \ / \   \/   |_| / \ |_)  /\  
		--__) |_| |_ |_ |_/ \_/   /\   | | \_/ | \ /--\                                                                  
		---------------------------------------------------------------------------------------------------------------------------------
		DECLARE @factor decimal(18,6) =0
		DECLARE @sueldo decimal(18,6) =0
		DECLARE @HoraBase  decimal(18,6) =0
		DECLARE @sueldoporhora  decimal(18,6) =0  

	    SET @factor =(SELECT chm.Factor FROM ERP.ConceptoHora  ch INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora WHERE ch.IdAnio =@anioFactor AND idMes = @mesFactor AND ch.IdConcepto =1)
		SELECT @sueldo= dld.Sueldo,@HoraBase= dld.HoraBase FROM ERP.DatoLaboralDetalle dld	 INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
			INNER JOIN ERP.PlanillaCabecera pc ON pc.IdDatoLaboralDetalle = dld.ID
			INNER JOIN ERP.Trabajador t ON dl.IdTrabajador = t.ID      INNER JOIN ERP.Persona p ON t.IdEntidad = p.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento etd ON p.IdEntidad = etd.IdEntidad  INNER JOIN PLE.T2TipoDocumento td ON etd.IdTipoDocumento = td.ID	
		WHERE 
			dld.FechaInicio<= @FechaFinNomina 	 AND (dld.FechaFin >=@FechaInicioNomina OR dld.FechaFin IS NULL) 
			AND dld.IdPlanilla = @idPlanilla AND DL.IdEmpresa = @idEmpresa	
			AND dl.IdTrabajador = @IdTrabajador
			IF @HoraBase<>0 
			BEGIN
			    -- ojo con las nominas semanales verificar 


				SELECT @sueldoporhora = (@sueldo/@HoraBaseTipoPlanilla)--+ @asignacionfamiliarHora --(((@sueldo + @asignacionfamiliar) / @HoraBase)/8)
		    END




		---------------------------------------------------------------------------------------------------------------------------------
		-- _    ___      ___            _          _  _           _        _  
		--|_ |   |  |\/|  |  |\ |  /\  |_)    /\  |_ |_)   \_/   / \ |\ | |_) 
		--|_ |_ _|_ |  | _|_ | \| /--\ | \   /--\ |  |      |    \_/ | \| |   y essalud
		---------------------------------------------------------------------------------------------------------------------------------

		DELETE FROM ERP.PlanillaPago WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND ERP.PlanillaPago.IdConcepto IN(47,48,50,49,108,79)




		---------------------------------------------------------------------------------------------------------------------------------
		--___       _   _   _ ___ _  __                               _  __ 
		-- |  |\/| |_) / \ |_) | |_ (_    |\/|  /\  |\ | | |  /\  |  |_ (_  
		--_|_ |  | |   \_/ | \ | |_ __)   |  | /--\ | \| |_| /--\ |_ |_ __)                                                                                                                                    
		---------------------------------------------------------------------------------------------------------------------------------
		--TIPO CONCEPTO														| -- CLASE
		-- 1 INGRESO  2 DESCUENTOS  3 APORTACIONES  4 TOTALES  5 PROVISION  | -- 1 IMPORTE 2 HORA 3 PORCENTAJE 4 CALCULO ESPECIAL 5 PORCENTAJE AFP


		DECLARE @SumacoImpM decimal(18,6) = 0
		DECLARE @IDcoImp int 
		DECLARE @ValorImp decimal(18,6)
		DECLARE db_cursorImporte CURSOR FOR 
		SELECT pht.IdConcepto, pht.HoraPorcentaje FROM ERP.PlanillaHojaTrabajo pht INNER JOIN ERP.Concepto c ON pht.IdConcepto = c.ID  
		WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND c.IdClase = 1 AND c.IdTipoConcepto = 1 
		OPEN db_cursorImporte  
		FETCH NEXT FROM db_cursorImporte INTO @IDcoImp ,@ValorImp 

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = @IDcoImp AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
			BEGIN
			    UPDATE ERP.PlanillaPago
			    SET
			        ERP.PlanillaPago.Calculo = @ValorImp 
				    WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = @IDcoImp
			END
			ELSE
			BEGIN
			  INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,@IDcoImp,0, @ValorImp)
			END

		  FETCH NEXT FROM db_cursorImporte INTO @IDcoImp ,@ValorImp
		END 

		CLOSE db_cursorImporte  
		DEALLOCATE db_cursorImporte


		---------------------------------------------------------------------------------------------------------------------------------
		-- _   _  __  _      _     ___ _   __                               _  __ 
		--| \ |_ (_  /  | | |_ |\ | | / \ (_    |\/|  /\  |\ | | |  /\  |  |_ (_  
		--|_/ |_ __) \_ |_| |_ | \| | \_/ __)   |  | /--\ | \| |_| /--\ |_ |_ __)
		---------------------------------------------------------------------------------------------------------------------------------
		--TIPO CONCEPTO														| -- CLASE
		-- 1 INGRESO  2 DESCUENTOS  3 APORTACIONES  4 TOTALES  5 PROVISION  | -- 1 IMPORTE 2 HORA 3 PORCENTAJE 4 CALCULO ESPECIAL 5 PORCENTAJE AFP

		DECLARE @SumaDescM decimal(18,6) = 0
		DECLARE @IDcoDesc int 
		DECLARE @ValorDesc decimal(18,6)
		DECLARE @CalcDesc decimal(18,6) =0
		DECLARE db_cursorDescuento CURSOR FOR 
		SELECT pht.IdConcepto, pht.HoraPorcentaje  FROM ERP.PlanillaHojaTrabajo pht INNER JOIN ERP.Concepto c ON pht.IdConcepto = c.ID  
		WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND c.IdClase = 1 AND c.IdTipoConcepto =2
		OPEN db_cursorDescuento  
		FETCH NEXT FROM db_cursorDescuento INTO @IDcoDesc ,@ValorDesc 
		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = @IDcoDesc AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
			BEGIN
			   UPDATE ERP.PlanillaPago
			   SET
			       ERP.PlanillaPago.Calculo = @ValorDesc 
				   WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = @IDcoDesc
			END
			ELSE
			BEGIN
			  INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,@IDcoDesc,0, @ValorDesc)
			END

				set @SumaDescM	=@SumaDescM + @ValorDesc
		  FETCH NEXT FROM db_cursorDescuento INTO @IDcoDesc ,@ValorDesc
		END 

		CLOSE db_cursorDescuento  
		DEALLOCATE db_cursorDescuento
		print '-----------------------------------------------------------------------------------'



		---------------------------------------------------------------------------------------------------------------------------------
		--___       _   _   _ ___ _  __        _   _       
		-- |  |\/| |_) / \ |_) | |_ (_    |_| / \ |_)  /\  
		--_|_ |  | |   \_/ | \ | |_ __)   | | \_/ | \ /--\                                                                                                                                                                                     
		---------------------------------------------------------------------------------------------------------------------------------
		--TIPO CONCEPTO														| -- CLASE
		-- 1 INGRESO  2 DESCUENTOS  3 APORTACIONES  4 TOTALES  5 PROVISION  | -- 1 IMPORTE 2 HORA 3 PORCENTAJE 4 CALCULO ESPECIAL 5 PORCENTAJE AFP

		--SELECT chm.Factor FROM erp.ConceptoHora ch INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora WHERE ch.IdConcepto = 1 AND ch.IdAnio = 9 AND chm.IdMes=10

		--SELECT * FROM ERP.PlanillaHojaTrabajo pht WHERE pht.IdPlanillaCabecera =171
		--SELECT * FROM ERP.Concepto c WHERE c.id IN (32,33,1) --REMUNERACIÓN BÁSICA tipo =1 clase = 2

		DECLARE @IDcoImpHora int 
		DECLARE @ValorImpHora decimal(18,6)
		DECLARE db_cursorImporteH CURSOR FOR SELECT pht.IdConcepto, pht.HoraPorcentaje FROM ERP.PlanillaHojaTrabajo pht INNER JOIN ERP.Concepto c ON pht.IdConcepto = c.ID  
											 WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND c.IdClase = 2 AND c.IdTipoConcepto = 1 
		OPEN db_cursorImporteH  
		FETCH NEXT FROM db_cursorImporteH INTO @IDcoImpHora ,@ValorImpHora 

		WHILE @@FETCH_STATUS = 0  
		BEGIN 

		        ------ calculos--------------------


						--DECLARE @IdConceptoEvaluar  int =32
						DECLARE @SumaImporteH   decimal (18,6)=0
						DECLARE @factorEvaluar  decimal(18,6)=0
						SELECT TOP 1  @factorEvaluar= chm.Factor  FROM ERP.ConceptoHora ch 	INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora
												INNER JOIN ERP.ConceptoHoraMesDetalle chmd ON chm.ID = chmd.IdConceptoHoraMes	LEFT JOIN erp.Concepto c ON chmd.IdConcepto = c.ID
												WHERE ch.IdAnio =@anioIDFactor AND chm.IdMes= @mesFactor AND ch.IdConcepto= @IDcoImpHora

						DECLARE @CurrentIDConcepto INT
						DECLARE cursor_results CURSOR FOR SELECT   chmd.IdConcepto FROM ERP.ConceptoHora ch INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora
												INNER JOIN ERP.ConceptoHoraMesDetalle chmd ON chm.ID = chmd.IdConceptoHoraMes LEFT JOIN erp.Concepto c ON chmd.IdConcepto = c.ID
												WHERE ch.IdAnio =@anioIDFactor AND chm.IdMes= @mesFactor AND ch.IdConcepto= @IDcoImpHora 

						OPEN cursor_results
						FETCH NEXT FROM cursor_results into @CurrentIDConcepto
						WHILE @@FETCH_STATUS = 0
						BEGIN 

						 DECLARE @Currentfactor decimal (18,6)=0

							IF @CurrentIDConcepto <>2 --AsignacionFamiliar
							BEGIN
								IF (@RegimenLaboral <> 19) -- normal
								BEGIN
								 SET @Currentfactor =(SELECT TOP 1  chm.Factor  	 FROM ERP.ConceptoHora ch 	INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora
													INNER JOIN ERP.ConceptoHoraMesDetalle chmd ON chm.ID = chmd.IdConceptoHoraMes LEFT JOIN erp.Concepto c ON chmd.IdConcepto = c.ID
													WHERE ch.IdAnio =@anioIDFactor AND chm.IdMes= @mesFactor AND ch.IdConcepto= @IDcoImpHora)*@sueldoporhora*@ValorImpHora

								END
							END
							ELSE
							BEGIN
							  SET @Currentfactor =(@asignacionfamiliarHora+@sueldoporhora) *@factorEvaluar*@ValorImpHora
							  IF (@RegimenLaboral <> 19) -- normal
							   BEGIN
							    SET @Currentfactor =(@asignacionfamiliarHora+@sueldoporhora) *@factorEvaluar*@ValorImpHora
							 END
							 IF (@RegimenLaboral = 19) -- regimen agrario
							 BEGIN
							    IF (@HorasEfectivasX >=@HoraBaseTipoPlanilla) --asistencia perfecta
								BEGIN
								   SET @Currentfactor =(@asignacionfamiliarHora+@sueldoporhora) *@factorEvaluar*@ValorImpHora
								END 
							 END
							END

							SET @SumaImporteH = @SumaImporteH +@Currentfactor


						FETCH NEXT FROM cursor_results into @CurrentIDConcepto
						END

						CLOSE cursor_results;
						DEALLOCATE cursor_results;


		-----------------------------------

			 IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = @IDcoImpHora AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
			 BEGIN
			    DECLARE @FactorImporteHora decimal(15,4) =0 
			    SELECT @FactorImporteHora = chm.Factor FROM erp.ConceptoHora ch INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora WHERE ch.IdConcepto = @CurrentIDConcepto AND ch.IdAnio = @anioIDFactor AND chm.IdMes=@mesFactor

			    UPDATE ERP.PlanillaPago
			    SET
			        ERP.PlanillaPago.Calculo =@SumaImporteH
				    WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = @IDcoImpHora
			 END
			 ELSE
			 BEGIN
			   INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,@IDcoImpHora,0, @SumaImporteH)
			 END

		  FETCH NEXT FROM db_cursorImporteH INTO @IDcoImpHora ,@ValorImpHora
		END 

		CLOSE db_cursorImporteH  
		DEALLOCATE db_cursorImporteH


		---------------------------------------------------------------------------------------------------------------------------------
		-- ___ ____ _    ____ _  _ _    ____ ____    ____ ____ ___  ____ ____ _ ____ _    ____ ____ 
		--|    |__| |    |    |  | |    |  | [__     |___ [__  |__] |___ |    | |__| |    |___ [__  
		--|___ |  | |___ |___ |__| |___ |__| ___]    |___ ___] |    |___ |___ | |  | |___ |___ ___] 
		---------------------------------------------------------------------------------------------------------------------------------

				--doninical id 3
		DECLARE @dominicalFlag int 
		SET @dominicalFlag =( SELECT c.FlagSiemprePlanilla FROM erp.concepto c WHERE c.id = 3 )
		IF (@dominicalFlag=1)
		BEGIN
		DECLARE @valorDominico decimal(15,5)
		 IF (@RegimenLaboral = 19) -- regimen agrario
			BEGIN
			    SET @valorDominico= ((@HorasEfectivasX)/8) /6

				IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 3 AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
				BEGIN
						UPDATE ERP.PlanillaPago
						 SET
						ERP.PlanillaPago.Calculo = @valorDominico 
						WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 3
				END
				ELSE
				BEGIN
						 INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,3,0, @valorDominico)
				END
		 END

		 END
	
	     


			-- feriado no laborado agrario  id 118
		 IF (@RegimenLaboral = 19) -- regimen agrario

			DECLARE @fdnFlag int 
			SET @fdnFlag =(SELECT pht.IdConcepto FROM ERP.PlanillaHojaTrabajo pht INNER JOIN ERP.Concepto c ON pht.IdConcepto = c.ID  
			WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND pht.IdConcepto =30  )
			PRINT '@@fdnFlag ' + cast(@fdnFlag AS varchar(19))
			IF (@fdnFlag=30)
			BEGIN
			DECLARE @valorfdn decimal(15,5)
			DECLARE @cantfnl decimal(15,5) = (SELECT  pht.HoraPorcentaje FROM ERP.PlanillaHojaTrabajo pht INNER JOIN ERP.Concepto c ON pht.IdConcepto = c.ID  
			WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND pht.IdConcepto =30 )
			PRINT '@@@cantfnl ' + cast(@cantfnl AS varchar(19))

			DECLARE @faltas decimal(15,5) =0
			IF EXISTS (SELECT  pht.HoraPorcentaje FROM ERP.PlanillaHojaTrabajo pht INNER JOIN ERP.Concepto c ON pht.IdConcepto = c.ID WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND pht.IdConcepto =68 )
			BEGIN
			SET @faltas = (SELECT  pht.HoraPorcentaje /8 FROM ERP.PlanillaHojaTrabajo pht INNER JOIN ERP.Concepto c ON pht.IdConcepto = c.ID  
			WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND pht.IdConcepto =68 )
			END
			PRINT '@@@@faltas ' + cast(@faltas AS varchar(19))
			BEGIN
			    SET @valorfdn= @cantfnl /15 * (15-@faltas)
				PRINT '---@@@@valorfdn ' + cast(@valorfdn AS varchar(19))
				IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 118 AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
				BEGIN
						UPDATE ERP.PlanillaPago
						 SET
						ERP.PlanillaPago.Calculo = @valorfdn 
						WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 118
				END
				ELSE
				BEGIN
						 INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,118,0, @valorfdn)
				END
		 END

		 END


		--horas trabajadas id 1
		
		DECLARE @dominicalValor decimal(15,5) = 0
		DECLARE @feriadoValor decimal(15,5) =0
		IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 3 AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
		BEGIN
		  SET @dominicalValor =(SELECT pp.Calculo FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 3 AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
		END
		IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 118 AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
		BEGIN
		  SET @feriadoValor =(SELECT pp.Calculo FROM ERP.PlanillaPago pp WHERE pp.IdConcepto =118 AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
		END
		

		DECLARE @valorBasico19 decimal(15,5)
		 IF (@RegimenLaboral = 19) -- regimen agrario
			BEGIN
			    SET @valorBasico19= 36.29 *((@HorasEfectivasX/8)+@dominicalValor +@feriadoValor)
				PRINT 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
				PRINT ' --@@HorasEfectivasX  ' + cast(@HorasEfectivasX AS varchar(19)) 
				PRINT ' --@@dominicalValor  ' + cast(@dominicalValor AS varchar(19)) 
				PRINT ' --@@feriadoValor  ' + cast(@feriadoValor AS varchar(19)) 
				PRINT ' --@@valorBasico19  ' + cast(@valorBasico19 AS varchar(19)) 
				PRINT 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
				IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 1 AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
				BEGIN
						UPDATE ERP.PlanillaPago
						 SET
						ERP.PlanillaPago.Calculo = @valorBasico19 
						WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 1
				END
				ELSE
				BEGIN
						 INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,1,0, @valorBasico19)
				END
		 END

		-- asignacion familiar
		DECLARE @asigFam decimal(15,5) =0
		DECLARE @bitFam bit   =0
	    set @bitFam=	(SELECT dl.FlagAsignacionFamiliar FROM ERP.DatoLaboralDetalle dld INNER JOIN ERP.DatoLaboral dl ON dld.IdDatoLaboral = dl.ID WHERE DLD.ID = @idDatoLaboralDetalle)
		PRINT ' --@@@HorasEfectivasX  ' + cast(@HorasEfectivasX AS varchar(19))  
		IF (@bitFam = 1 AND @RegimenLaboral = 19)
		BEGIN
			IF ((@HorasEfectivasX/8) >=12)
			BEGIN
			SET @asigFam = 46.5
			END
			ELSE
			BEGIN
			SET @asigFam =((@HorasEfectivasX/8)+@dominicalValor+@feriadoValor )*3.1
			END
			PRINT 'x--------------------------------------------------------------------------------------------xx'
			PRINT ' --@asigFam  ' + cast(@asigFam AS varchar(19)) 
			PRINT 'x--------------------------------------------------------------------------------------------xx'
			   IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 2 AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
				BEGIN
						UPDATE ERP.PlanillaPago
						 SET
						ERP.PlanillaPago.Calculo = @asigFam 
						WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 2
				END
				ELSE
				BEGIN
						 INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,2,0, @asigFam)
				END
		END



		---------------------------------------------------------------------------------------------------------------------------------
		 -- _   _  __  _      _     ___ _   __        _   _       
		 --| \ |_ (_  /  | | |_ |\ | | / \ (_    |_| / \ |_)  /\  
		 --|_/ |_ __) \_ |_| |_ | \| | \_/ __)   | | \_/ | \ /--\                                                                                                                                                                               
		---------------------------------------------------------------------------------------------------------------------------------
		--TIPO CONCEPTO														| -- CLASE
		-- 1 INGRESO  2 DESCUENTOS  3 APORTACIONES  4 TOTALES  5 PROVISION  | -- 1 Descuento 2 HORA 3 PORCENTAJE 4 CALCULO ESPECIAL 5 PORCENTAJE AFP

		--SELECT chm.Factor FROM erp.ConceptoHora ch INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora WHERE ch.IdConcepto = 1 AND ch.IdAnio = 9 AND chm.IdMes=10

		--SELECT * FROM ERP.Concepto c WHERE c.id IN (32,33,1) --REMUNERACIÓN BÁSICA tipo =1 clase = 2

		DECLARE @IDcoDesHora int 
		DECLARE @ValorDesHora decimal(18,6)
		DECLARE db_cursorDescuentoH CURSOR FOR SELECT pht.IdConcepto, pht.HoraPorcentaje FROM ERP.PlanillaHojaTrabajo pht INNER JOIN ERP.Concepto c ON pht.IdConcepto = c.ID  
											 WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND c.IdClase = 2 AND c.IdTipoConcepto = 2
		OPEN db_cursorDescuentoH  
		FETCH NEXT FROM db_cursorDescuentoH INTO @IDcoDesHora ,@ValorDesHora 

		WHILE @@FETCH_STATUS = 0  
		BEGIN 

		        ------ calculos--------------------
						DECLARE @SumaDescuentoH   decimal (18,6)=0
						DECLARE @factorEvaluarH  decimal(18,6)=0
						SELECT TOP 1  @factorEvaluar= chm.Factor  FROM ERP.ConceptoHora ch 	INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora
												INNER JOIN ERP.ConceptoHoraMesDetalle chmd ON chm.ID = chmd.IdConceptoHoraMes	LEFT JOIN erp.Concepto c ON chmd.IdConcepto = c.ID
												WHERE ch.IdAnio =@anioIDFactor AND chm.IdMes= @mesFactor AND ch.IdConcepto= @IDcoDesHora


						DECLARE cursor_results CURSOR FOR SELECT   chmd.IdConcepto FROM ERP.ConceptoHora ch INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora
												INNER JOIN ERP.ConceptoHoraMesDetalle chmd ON chm.ID = chmd.IdConceptoHoraMes LEFT JOIN erp.Concepto c ON chmd.IdConcepto = c.ID
												WHERE ch.IdAnio =@anioIDFactor AND chm.IdMes= @mesFactor AND ch.IdConcepto= @IDcoDesHora 

						OPEN cursor_results
						FETCH NEXT FROM cursor_results into @CurrentIDConcepto
						WHILE @@FETCH_STATUS = 0
						BEGIN 

						 DECLARE @CurrentfactorD decimal (18,6)=0

							IF @CurrentIDConcepto <>2 --AsignacionFamiliar
							BEGIN
							 SET @Currentfactor =(SELECT TOP 1  chm.Factor  	 FROM ERP.ConceptoHora ch 	INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora
												INNER JOIN ERP.ConceptoHoraMesDetalle chmd ON chm.ID = chmd.IdConceptoHoraMes LEFT JOIN erp.Concepto c ON chmd.IdConcepto = c.ID
												WHERE ch.IdAnio =@anioIDFactor AND chm.IdMes= @mesFactor AND ch.IdConcepto= @IDcoDesHora)*@sueldoporhora*@ValorDesHora


							END
							ELSE
							BEGIN

							  SET @Currentfactor =(@asignacionfamiliarHora+@sueldoporhora) *@factorEvaluar*@ValorDesHora
							END

							SET @SumaDescuentoH = @SumaDescuentoH +@Currentfactor


						FETCH NEXT FROM cursor_results into @CurrentIDConcepto
						END

						CLOSE cursor_results;
						DEALLOCATE cursor_results;


		-----------------------------------

			 IF  EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = @IDcoDesHora AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
			 BEGIN
			    DECLARE @FactorDescuentoHora decimal(15,6) =0 
			    SELECT @FactorDescuentoHora = chm.Factor FROM erp.ConceptoHora ch INNER JOIN ERP.ConceptoHoraMes chm ON ch.ID = chm.IdConceptoHora WHERE ch.IdConcepto = @CurrentIDConcepto AND ch.IdAnio = @anioIDFactor AND chm.IdMes=@mesFactor

			    UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@SumaDescuentoH
				    WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = @IDcoDesHora
			 END
			 ELSE
			 BEGIN
			   INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,@IDcoDesHora,0, @SumaDescuentoH)
			 END

		  FETCH NEXT FROM db_cursorDescuentoH INTO @IDcoImpHora ,@ValorImpHora
		END 

		CLOSE db_cursorDescuentoH  
		DEALLOCATE db_cursorDescuentoH














		---------------------------------------------------------------------------------------------------------------------------------
		 -- _  _        __ ___ _       _  _ ___  _          _ ___    ___    
		 --/  / \ |\ | (_   | |_) | | /  /   |  / \ |\ |   /   | \  / |  |  
		 --\_ \_/ | \| __)  | | \ |_| \_ \_ _|_ \_/ | \|   \_ _|_ \/ _|_ |_                                                           
		---------------------------------------------------------------------------------------------------------------------------------

		-- si existe un solo trabajador con onp, agregar filas para cada uno de ellos en planillapago en 0 y luego actualizar el que existe
		--IF (SELECT count(dld.ID) FROM ERP.DatoLaboralDetalle dld 
		--	WHERE DLD.ID = @IdDatoLaboralDetalle AND dld.IdSituacionEspecialTrabajador= 22) >0
		--BEGIN

		--END




		-- --------------------------------------------------------------------------------------------------------------------------------









		 -- _  _   __ 
		 --|_ |_) (_  
		 --|_ |   __)                             
		-----------------------------------------------------------------------------------------------------------------------------------

		IF (SELECT COUNT(dls.ID) FROM ERP.DatoLaboralSalud dls WHERE
			dls.FechaInicio<= @FechaFinNomina  AND (dls.FechaFin >=@FechaInicioNomina OR dls.FechaFin IS NULL) AND
			dls.IdRegimenSalud = 2 )>0
		BEGIN
		-- si existe un solo trabajador con onp, agregar filas para cada uno de ellos en planillapago en 0 y luego actualizar el que existe
		  DECLARE @factorEvaluarEPS decimal(18,6) =0 
		  DECLARE @EPS  decimal(18,6) =0 
		  SELECT TOP 1 @factorEvaluarEPS = cpm.Porcentaje FROM ERP.ConceptoPorcentaje cp
								INNER JOIN ERP.ConceptoPorcentajeMes cpm ON cp.ID = cpm.IDCONCEPTOPORCENTAJE
								INNER JOIN ERP.ConceptoPorcentajeMesDetalle cpmd ON cpm.ID = cpmd.IdConceptoPorcentajeMes WHERE cp.IdConcepto = 80 AND cpm.IdMes = @mesFactor   AND cp.IdAnio = @anioIDFactor
								AND CP.IdRegimenLaboral = @RegimenLaboral


					SET @EPS =( SELECT sum(A.Calculo) AS Total FROM ERP.ConceptoPorcentaje cp
								INNER JOIN ERP.ConceptoPorcentajeMes cpm ON cp.ID = cpm.IDCONCEPTOPORCENTAJE
								INNER JOIN ERP.ConceptoPorcentajeMesDetalle cpmd ON cpm.ID = cpmd.IdConceptoPorcentajeMes 
								RIGHT JOIN (SELECT pp.IdConcepto, pp.Calculo FROM ERP.PlanillaPago pp WHERE pp.IdPlanillaCabecera =@IdPlanillaCabecera) AS  A ON a.IdConcepto = cpmd.IdConcepto
								WHERE cp.IdConcepto = 80 AND cpm.IdMes = @mesFactor   AND cp.IdAnio = @anioIDFactor AND CP.IdRegimenLaboral = @RegimenLaboral) * @factorEvaluarEPS
						IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 80  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
						BEGIN
							UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@EPS
							 WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 80
						END
						ELSE
						BEGIN
							INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,80,0, @EPS)
						END								



		END

		---------------------------------------------------------------------------------------------------------------------------------------
		-- PENDIENTES -ESSALUD TRAB PESQUEROS  ESSALUD TRAB PESQ Y EPS(SERV.PROP) ESSALUD AGRARIO/ACUÍCOLA  ESSALUD PENSIONISTAS  SANIDAD FFAA Y POLICIALES (1) SIS – MICROEMPRESA (2)
		---------------------------------------------------------------------------------------------------------------------------------------

		 ---------------------------------------------------------------------------------------------------------------------------------------
		 -- __  _ ___ _  
		 --(_  /   | |_) 
		 --__) \_  | | \ 
		 --------------------------------------------------------------------------------------------------------------------------------------- 


		IF (SELECT COUNT(dls.ID) FROM ERP.SCTR dls WHERE
			dls.FechaInicio<= @FechaFinNomina  AND (dls.FechaFin >=@FechaInicioNomina OR dls.FechaFin IS NULL) AND
			dls.IdDatoLaboral = @IdatoLaboral )>0
		BEGIN
		-- si existe un solo trabajador con scrt, agregar filas para cada uno de ellos en planillapago en 0 y luego actualizar el que existe
			DECLARE @SCTRtrabajador  int
			SELECT TOP 1 @SCTRtrabajador= CASE 	WHEN (s.IdTipoSalud = 1 AND s.IdTipoPension = 1) THEN  82
												WHEN (s.IdTipoSalud = 2 AND s.IdTipoPension = 1) THEN  85
												WHEN (s.IdTipoSalud = 2 AND s.IdTipoPension = 2) THEN  83	 
												WHEN (s.IdTipoSalud = 1 AND s.IdTipoPension = 2) THEN  84
										  END		
										   FROM ERP.SCTR s WHERE s.IdDatoLaboral  = @IdatoLaboral  AND 
										   s.FechaInicio<= @FechaFinNomina  AND (s.FechaFin >=@FechaInicioNomina OR s.FechaFin IS NULL) 
										   ORDER BY s.ID DESC


		  DECLARE @factorEvaluarSCTR decimal(18,6) =0 
		  DECLARE @SCTR  decimal(18,6) =0 
		  SELECT TOP 1 @factorEvaluarSCTR = cpm.Porcentaje FROM ERP.ConceptoPorcentaje cp
								INNER JOIN ERP.ConceptoPorcentajeMes cpm ON cp.ID = cpm.IDCONCEPTOPORCENTAJE
								INNER JOIN ERP.ConceptoPorcentajeMesDetalle cpmd ON cpm.ID = cpmd.IdConceptoPorcentajeMes WHERE cp.IdConcepto = @SCTRtrabajador AND cpm.IdMes = @mesFactor   AND cp.IdAnio = @anioIDFactor
								AND CP.IdRegimenLaboral = @RegimenLaboral;
					SET @SCTR =( SELECT sum(A.Calculo) AS Total FROM ERP.ConceptoPorcentaje cp
								INNER JOIN ERP.ConceptoPorcentajeMes cpm ON cp.ID = cpm.IDCONCEPTOPORCENTAJE
								INNER JOIN ERP.ConceptoPorcentajeMesDetalle cpmd ON cpm.ID = cpmd.IdConceptoPorcentajeMes 
								RIGHT JOIN (SELECT pp.IdConcepto, pp.Calculo FROM ERP.PlanillaPago pp WHERE pp.IdPlanillaCabecera =@IdPlanillaCabecera) AS  A ON a.IdConcepto = cpmd.IdConcepto
								WHERE cp.IdConcepto = @SCTRtrabajador AND cpm.IdMes = @mesFactor   AND cp.IdAnio = @anioIDFactor AND CP.IdRegimenLaboral = @RegimenLaboral) * (@factorEvaluarSCTR/100)


						IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = @SCTRtrabajador  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
						BEGIN
							UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@SCTR
							 WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = @SCTRtrabajador
						END
						ELSE
						BEGIN
							INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,@SCTRtrabajador,0, @SCTR)
						END	


		END




		---------------------------------------------------------------------------------------------------------------
		-- __              ___ _   _  ___        ___       _   _   _ ___ _  __     _   _  __  _      _     ___ _   __ 
		--(_  | | |\/|  /\  | / \ |_)  |   /\     |  |\/| |_) / \ |_) | |_ (_   / | \ |_ (_  /  | | |_ |\ | | / \ (_  
		--__) |_| |  | /--\ | \_/ | \ _|_ /--\   _|_ |  | |   \_/ | \ | |_ __) /  |_/ |_ __) \_ |_| |_ | \| | \_/ __) 

		-- calculos internos (ONP)
		---------------------------------------------------------------------------------------------------------------                                                                                                             

		 -- IMPORTES ---
		 DECLARE @SumaTotalIMPORTES decimal(18,6) =0  
		 set  @SumaTotalIMPORTES = isnull( (select sum(Calculo) 
			FROM ERP.DatoLaboralDetalle dld     
			INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
			INNER JOIN ERP.PlanillaCabecera pc ON dld.ID = pc.IdDatoLaboralDetalle
			INNER JOIN erp.PlanillaPago pp ON pc.id = pp.IdPlanillaCabecera
			INNER JOIN ERP.Concepto c ON c.ID = pp.IdConcepto
			WHERE 
				dld.FechaInicio<= @FechaFinNomina  AND (dld.FechaFin >=@FechaInicioNomina OR dld.FechaFin IS NULL) 
				AND c.IdTipoConcepto = 1 AND pp.IdPlanillaCabecera = @IdPlanillaCabecera),0)

		-- SET @SumaTotalIMPORTES = @SumacoImpM +@SumaImporteH
		 -- DESCUENTOS --
		 DECLARE @SumaTotalDESCUENTOS decimal(18,6) =0 
		 SET @SumaTotalDESCUENTOS =@SumaDescuentoH +@SumaDescM
		 -- DIFERENCIA --
		 DECLARE @SumaTotal decimal(18,6) =0  
		 SET @SumaTotal = @SumaTotalIMPORTES-@SumaTotalDESCUENTOS



	-------------------------------------------------------------------------------------------------------------------------------------------------------------	
	-- _  _        _  _  _ ___ _          _   _  _  _  _ ___ _          _       _      _       _   _  
	--/  / \ |\ | /  |_ |_) | / \   \/   | \ |_ |_ |_ /   | / \   \/   |_ |\/| |_) |  |_  /\  | \ / \ 
	--\_ \_/ | \| \_ |_ |   | \_/   /\   |_/ |_ |  |_ \_  | \_/   /\   |_ |  | |   |_ |_ /--\ |_/ \_/ 
   	-------------------------------------------------------------------------------------------------------------------------------------------------------------	                                                                                              	
			DECLARE @PDIdDatoLaboral int=0
			DECLARE @PDIdConcepto int=0
			DECLARE @PDTipoConceptoFijo int=0
			DECLARE @PDMonto decimal(18,6)=0
			DECLARE @PDMontoCalculado as decimal(18,6)=0
			DECLARE @Description AS nvarchar(400)
			DECLARE CursorConceptoPD CURSOR FOR SELECT B.IdDatoLaboral, B.IdConcepto, B.IdTipoConceptoFijo, B.Monto FROM
					(SELECT A.IdDatoLaboral, A.IdConcepto, A.IdTipoConceptoFijo, A.Monto, EOMONTH (cast(A.AnioC AS varchar(20)) +'-'+ cast(A.MesFin AS varchar(20)) +'-01')  AS Fecha  FROM 
					(SELECT dlcf.ID, 
						   dlcf.IdDatoLaboral, 
						   dlcf.IdConcepto, 
						   dlcf.IdTipoConceptoFijo, 
						   dlcf.IdEmpresa, 
						   dlcf.IdPeriodoInicio, 
						   dlcf.IdPeriodoFin, 
						   dlcf.Monto, 
						   (SELECT p.IdAnio FROM ERP.Periodo p WHERE p.id = dlcf.IdPeriodoInicio) AS AnioInicio,
						   (SELECT p.IdMes FROM ERP.Periodo p WHERE p.id = dlcf.IdPeriodoInicio) AS MesInicio,
						   (SELECT p.IdAnio FROM ERP.Periodo p WHERE p.id = isnull(dlcf.IdPeriodoFin,dlcf.IdPeriodoInicio) ) AS AnioFin,
						   (SELECT p.IdMes FROM ERP.Periodo p WHERE p.id = isnull(dlcf.IdPeriodoFin,12) ) AS MesFin,
						   (SELECT TOP 1 Nombre FROM Maestro.Anio a WHERE a.id =(SELECT p.IdAnio FROM ERP.Periodo p WHERE p.id = isnull(dlcf.IdPeriodoFin,dlcf.IdPeriodoInicio) ) ) as AnioC
					FROM ERP.DatoLaboralConceptoFijo dlcf INNER JOIN ERP.DatoLaboral dl ON dlcf.IdDatoLaboral = dl.ID  INNER JOIN ERP.DatoLaboralDetalle dld ON dl.ID = dld.IdDatoLaboral
					WHERE dld.ID = @IdDatoLaboralDetalle) A ) B WHERE B.Fecha >=@FechaFinNomina 
			OPEN CursorConceptoPD
			FETCH NEXT FROM CursorConceptoPD INTO @PDIdDatoLaboral,@PDIdConcepto,@PDTipoConceptoFijo,@PDMonto
			WHILE @@fetch_status = 0
			BEGIN
			PRINT 'CONCEPTO : ' + cast( @PDIdConcepto AS varchar(20))
				DECLARE @Importe int =0
				SELECT @Importe = c.IdTipoConcepto FROM ERP.Concepto c WHERE c.id = @PDIdConcepto

								IF @PDTipoConceptoFijo = 1 -- fijo
								BEGIN
								   SET @PDMontoCalculado = @PDMonto
								END
								ELSE	
								BEGIN
									DECLARE @HorasEfectivas decimal(18,6) =0
									SELECT @HorasEfectivas= pht.HoraPorcentaje  FROM ERP.PlanillaHojaTrabajo pht WHERE pht.IdPlanillaCabecera = @IdPlanillaCabecera AND pht.IdConcepto =1	
									SET @PDMontoCalculado = (@PDMonto/@HoraBaseTipoPlanilla)*@HorasEfectivas
								END

								IF NOT EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = @PDIdConcepto AND pp.IdPlanillaCabecera =@idPlanillaCabecera)
								BEGIN
									 -- PRINT 'CAMPO AUTO  insert pago planilla ' + cast(@idPlanillaCabecera AS varchar(20)) + '  monto  '  + cast( @PDMontoCalculado AS varchar(20))+ '  concepto  '  + cast( @PDIdConcepto AS varchar(20))

									 INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @idPlanillaCabecera,@PDIdConcepto,0, @PDMontoCalculado)

								END
								ELSE
								BEGIN

								 -- PRINT 'CAMPO AUTO  update pago planilla ' + cast(@idPlanillaCabecera AS varchar(20)) + '  monto  '  + cast( @PDMontoCalculado AS varchar(20))+ '  concepto  '  + cast( @PDIdConcepto AS varchar(20))
									     UPDATE ERP.PlanillaPago  SET ERP.PlanillaPago.Calculo = @PDMontoCalculado WHERE ERP.PlanillaPago.IdPlanillaCabecera = @idPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = @PDIdConcepto

								END


				FETCH NEXT FROM CursorConceptoPD INTO @PDIdDatoLaboral,@PDIdConcepto,@PDTipoConceptoFijo,@PDMonto
			END
			CLOSE CursorConceptoPD
			DEALLOCATE CursorConceptoPD		


		-- --------------------------------------------------------------------------------------------------------------------------------
		--  _  __  __              _     _   _  __              _        _                                                
		-- |_ (_  (_   /\  |  | | | \   |_) |_ /__ | | |   /\  |_)    / |_     _ |      _ o     _. ._ _   _  ._ _|_  _ \  
		-- |_ __) __) /--\ |_ |_| |_/   | \ |_ \_| |_| |_ /--\ | \   |  |_ >< (_ | |_| _> | \/ (_| | | | (/_ | | |_ (/_ | 
		--                                                            \                                                /  
		-----------------------------------------------------------------------------------------------------------------------------------

		IF (SELECT COUNT(dls.ID) FROM ERP.DatoLaboralSalud dls WHERE
			dls.FechaInicio<= @FechaFinNomina  AND (dls.FechaFin >=@FechaInicioNomina OR dls.FechaFin IS NULL) AND
			dls.IdRegimenSalud = 1 )>0
		BEGIN
		-- si existe un solo trabajador con onp, agregar filas para cada uno de ellos en planillapago en 0 y luego actualizar el que existe
		  DECLARE @factorEvaluarESSALUD decimal(18,6) =0 
		  DECLARE @ESSALUD  decimal(18,6) =0 
		  SELECT TOP 1 @factorEvaluarESSALUD = cpm.Porcentaje FROM ERP.ConceptoPorcentaje cp
								INNER JOIN ERP.ConceptoPorcentajeMes cpm ON cp.ID = cpm.IDCONCEPTOPORCENTAJE
								INNER JOIN ERP.ConceptoPorcentajeMesDetalle cpmd ON cpm.ID = cpmd.IdConceptoPorcentajeMes WHERE cp.IdConcepto = 79 AND cpm.IdMes = @mesFactor   AND cp.IdAnio = @anioIDFactor
								AND CP.IdRegimenLaboral = @RegimenLaboral;
								 


					SET @ESSALUD =( SELECT sum(A.Calculo) AS Total FROM ERP.ConceptoPorcentaje cp
								INNER JOIN ERP.ConceptoPorcentajeMes cpm ON cp.ID = cpm.IDCONCEPTOPORCENTAJE
								INNER JOIN ERP.ConceptoPorcentajeMesDetalle cpmd ON cpm.ID = cpmd.IdConceptoPorcentajeMes 
								RIGHT JOIN (SELECT pp.IdConcepto, pp.Calculo FROM ERP.PlanillaPago pp WHERE pp.IdPlanillaCabecera =@IdPlanillaCabecera) AS  A ON a.IdConcepto = cpmd.IdConcepto
								WHERE cp.IdConcepto = 79 AND cpm.IdMes = @mesFactor   AND cp.IdAnio = @anioIDFactor AND CP.IdRegimenLaboral = @RegimenLaboral) * (@factorEvaluarESSALUD/100)

						IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 79  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
						BEGIN
							UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@ESSALUD
							 WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 79
						END
						ELSE
						BEGIN
							INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,79,0, @ESSALUD)
						END



		END



							---------------------------------------------------------------------------------------------------------------------------------
		--        __ __                             
		--	  /\ |_ |__)  | _    _ |  . _| _  _| _  
	    --   /--\|  |     |(_|  (_)|\/|(_|(_|(_|(_| 
        ---------------------------------------------------------------------------------------------------------------------------------


		DECLARE @CurrentIDConceptoAFP int 
		DECLARE @AFP  decimal(18,2) =0 
		DECLARE @CurrentfactorAFP decimal(18,2) =0 
		DECLARE @TipoRegimen int = 0
		DECLARE @TipoAFP int = 0
		DECLARE @TipoComision int = 0

		DECLARE @TotalFondoAFP  decimal(18,2)=0
		DECLARE @TotalSeguroAFP  decimal(18,2)=0
		DECLARE @TotalComisionMixtaAFP  decimal(18,2)=0
		DECLARE @TotalComisionFlujoAFP  decimal(18,2)=0

		DECLARE @FactorFondoAFP  decimal(18,5)=0
		DECLARE @FactorSeguroAFP  decimal(18,5)=0
		DECLARE @FactorComisionMixtaAFP  decimal(18,5)=0
		DECLARE @FactorComisionFlujoAFP  decimal(18,5)=0

		IF (SELECT count(tp.ID) FROM ERP.TrabajadorPension tp WHERE 
		tp.FechaInicio<= @FechaFinNomina  AND (tp.FechaFin >=@FechaInicioNomina OR tp.FechaFin IS NULL)   
		AND tp.IdTrabajador = @IdTrabajador 
		AND tp.IdRegimenPensionario IN(7,12,9,10)) > 0  --(INTEGRA,HABITAT,PROFUTURO,PRIMA)
		--SELECT * FROM ERP.AFP a --1 PRIMA  2 INTEGRA  3 PROFUTURO, 4 HABITAT
		--SELECT * FROM PLAME.T11RegimenPensionario tp
		BEGIN

		 -- TipoComision 1 FLUJO 2 MIXTA
		 SELECT top 1 @TipoRegimen= tp.IdRegimenPensionario, @TipoComision = tp.IdTipoComision FROM ERP.TrabajadorPension tp 
		 WHERE tp.FechaInicio<= @FechaFinNomina  AND (tp.FechaFin >=@FechaInicioNomina OR tp.FechaFin IS NULL) AND tp.IdTrabajador = @IdTrabajador


					SELECT @TipoAFP= CASE WHEN @TipoRegimen	=7  THEN    2 -- integra
							 WHEN @TipoRegimen	=12  THEN	4			  -- habitat
							 WHEN @TipoRegimen	=9  THEN	3			  -- profuturo
							 WHEN @TipoRegimen	=10 THEN    1			  -- prima
					 END	


						--FONDO PENSIONES --48
								SELECT @FactorFondoAFP = capm.Porcentaje FROM ERP.ConceptoAFP cax
								INNER JOIN ERP.ConceptoAFPMes cam ON cam.IdConceptoAFP = cax.ID
								INNER JOIN erp.ConceptoAFPMesDetalle camdx ON cam.ID = camdx.IdConceptoAFPMes
								INNER JOIN ERP.ConceptoAFPMesPorcentaje capm ON camdx.IdConceptoAFPMes = capm.IdConceptoAFPMes
								WHERE cax.IdAnio = @anioIDFactor AND cam.IdMes = @mesFactor AND capm.IdAFP =@TipoAFP AND cax.IdConcepto = 48 AND CAX.IdRegimenLaboral = @RegimenLaboral
								AND cax.IdRegimenLaboral = @RegimenLaboral

								set @TotalFondoAFP =(SELECT   (sum(pp.Calculo)*(@FactorFondoAFP/100)) FROM ERP.ConceptoAFP ca
								INNER JOIN ERP.ConceptoAFPMes cam ON cam.IdConceptoAFP = ca.ID
								INNER JOIN erp.ConceptoAFPMesDetalle camd ON cam.ID = camd.IdConceptoAFPMes
								INNER JOIN ERP.ConceptoAFPMesPorcentaje capm ON camd.IdConceptoAFPMes = capm.IdConceptoAFPMes
								INNER JOIN ERP.PlanillaPago pp ON pp.IdConcepto = camd.IdConcepto 
								WHERE ca.IdAnio= @anioIDFactor AND cam.IdMes = @mesFactor AND capm.IdAFP  =@TipoAFP AND ca.IdConcepto = 48 AND ca.IdRegimenLaboral = @RegimenLaboral
								AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)

								IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 48  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
								BEGIN
									UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@TotalFondoAFP
									WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 48
								END
								ELSE
								BEGIN
									INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,48,0, @TotalFondoAFP)
								END


					    -- SEGURO --50
								SELECT @FactorSeguroAFP =porcentaje FROM ERP.ConceptoAFP ca
								INNER JOIN ERP.ConceptoAFPMes cam ON cam.IdConceptoAFP = ca.ID
								INNER JOIN erp.ConceptoAFPMesDetalle camd ON cam.ID = camd.IdConceptoAFPMes
								INNER JOIN ERP.ConceptoAFPMesPorcentaje capm ON camd.IdConceptoAFPMes = capm.IdConceptoAFPMes
								WHERE ca.IdAnio = @anioIDFactor AND cam.IdMes = @mesFactor AND capm.IdAFP =@TipoAFP AND ca.IdConcepto = 50 AND ca.IdRegimenLaboral = @RegimenLaboral

								set @TotalSeguroAFP =(SELECT (sum(pp.Calculo)*(@FactorSeguroAFP/100)) FROM ERP.ConceptoAFP ca
								INNER JOIN ERP.ConceptoAFPMes cam ON cam.IdConceptoAFP = ca.ID
								INNER JOIN erp.ConceptoAFPMesDetalle camd ON cam.ID = camd.IdConceptoAFPMes
								INNER JOIN ERP.ConceptoAFPMesPorcentaje capm ON camd.IdConceptoAFPMes = capm.IdConceptoAFPMes
								INNER JOIN ERP.PlanillaPago pp ON pp.IdConcepto = camd.IdConcepto 
								WHERE ca.IdAnio= @anioIDFactor AND cam.IdMes = @mesFactor AND capm.IdAFP  =@TipoAFP AND ca.IdConcepto = 50 AND ca.IdRegimenLaboral = @RegimenLaboral
								AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)

								IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 50  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
								BEGIN
									UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@TotalSeguroAFP
									WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 50
								END
								ELSE
								BEGIN
									INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,50,0, @TotalSeguroAFP)
								END

						--COMISION (FLUJO O MIXTA) 49  / 108 
						if @TipoComision = 2
						begin
								SELECT @FactorComisionFlujoAFP =porcentaje FROM ERP.ConceptoAFP ca
								INNER JOIN ERP.ConceptoAFPMes cam ON cam.IdConceptoAFP = ca.ID
								INNER JOIN erp.ConceptoAFPMesDetalle camd ON cam.ID = camd.IdConceptoAFPMes
								INNER JOIN ERP.ConceptoAFPMesPorcentaje capm ON camd.IdConceptoAFPMes = capm.IdConceptoAFPMes
								WHERE ca.IdAnio = @anioIDFactor AND cam.IdMes = @mesFactor AND capm.IdAFP =@TipoAFP AND ca.IdConcepto = 49 AND ca.IdRegimenLaboral = @RegimenLaboral

								set @TotalComisionFlujoAFP =(SELECT  (sum(pp.Calculo)*(@FactorComisionFlujoAFP/100)) FROM ERP.ConceptoAFP ca
								INNER JOIN ERP.ConceptoAFPMes cam ON cam.IdConceptoAFP = ca.ID
								INNER JOIN erp.ConceptoAFPMesDetalle camd ON cam.ID = camd.IdConceptoAFPMes
								INNER JOIN ERP.ConceptoAFPMesPorcentaje capm ON camd.IdConceptoAFPMes = capm.IdConceptoAFPMes
								INNER JOIN ERP.PlanillaPago pp ON pp.IdConcepto = camd.IdConcepto 
								WHERE ca.IdAnio= @anioIDFactor AND cam.IdMes = @mesFactor AND capm.IdAFP  =@TipoAFP AND ca.IdConcepto = 49 AND ca.IdRegimenLaboral = @RegimenLaboral
								AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)

								IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 49  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
								BEGIN
									UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@TotalComisionFlujoAFP
									WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 49
								END
								ELSE
								BEGIN
									INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,49,0, @TotalComisionFlujoAFP)
								END
						end
						if @TipoComision = 1
						begin
								SELECT @FactorComisionMixtaAFP =porcentaje FROM ERP.ConceptoAFP ca
								INNER JOIN ERP.ConceptoAFPMes cam ON cam.IdConceptoAFP = ca.ID
								INNER JOIN erp.ConceptoAFPMesDetalle camd ON cam.ID = camd.IdConceptoAFPMes
								INNER JOIN ERP.ConceptoAFPMesPorcentaje capm ON camd.IdConceptoAFPMes = capm.IdConceptoAFPMes
								WHERE ca.IdAnio = @anioIDFactor AND cam.IdMes = @mesFactor AND capm.IdAFP =@TipoAFP AND ca.IdConcepto = 108 AND ca.IdRegimenLaboral = @RegimenLaboral

								set @TotalComisionMixtaAFP =(SELECT (sum(pp.Calculo)*(@FactorComisionMixtaAFP/100)) FROM ERP.ConceptoAFP ca
								INNER JOIN ERP.ConceptoAFPMes cam ON cam.IdConceptoAFP = ca.ID
								INNER JOIN erp.ConceptoAFPMesDetalle camd ON cam.ID = camd.IdConceptoAFPMes
								INNER JOIN ERP.ConceptoAFPMesPorcentaje capm ON camd.IdConceptoAFPMes = capm.IdConceptoAFPMes
								INNER JOIN ERP.PlanillaPago pp ON pp.IdConcepto = camd.IdConcepto 
								WHERE ca.IdAnio= @anioIDFactor AND cam.IdMes = @mesFactor AND capm.IdAFP  =@TipoAFP AND ca.IdConcepto = 108 AND ca.IdRegimenLaboral = @RegimenLaboral
								AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)

								IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 108  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
								BEGIN
									UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@TotalComisionMixtaAFP
									WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 108 
								END
								ELSE
								BEGIN
									INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,108,0, @TotalComisionMixtaAFP)
								END
						end


		END 









		---------------------------------------------------------------------------------------------------------------------------------
		-- _        _     _   _       __ ___  _        _  __ 
		--/ \ |\ | |_)   |_) |_ |\ | (_   |  / \ |\ | |_ (_  
		--\_/ | \| |     |   |_ | \| __) _|_ \_/ | \| |_ __) --DECRETO LEY 19990 - SISTEMA NACIONAL DE PENSIONES - ON
		---------------------------------------------------------------------------------------------------------------------------------



		DECLARE @CurrentIDConceptoONP int 
		DECLARE @ONP  decimal(18,6) =0 
		DECLARE @CurrentfactorONP decimal(18,6) =0 
		IF (SELECT count(tp.ID) FROM ERP.TrabajadorPension tp WHERE 
		tp.FechaInicio<= @FechaFinNomina  AND (tp.FechaFin >=@FechaInicioNomina OR tp.FechaFin IS NULL)   
		AND tp.IdTrabajador = @IdTrabajador 
		AND tp.IdRegimenPensionario = 1) > 0 

		BEGIN



						DECLARE @SumaONP   decimal (18,6)=0
						DECLARE @factorEvaluarONP  decimal(18,6)=0
						SELECT TOP 1 @factorEvaluarONP = cpm.Porcentaje FROM ERP.ConceptoPorcentaje cp
								INNER JOIN ERP.ConceptoPorcentajeMes cpm ON cp.ID = cpm.IDCONCEPTOPORCENTAJE
								INNER JOIN ERP.ConceptoPorcentajeMesDetalle cpmd ON cpm.ID = cpmd.IdConceptoPorcentajeMes WHERE cp.IdConcepto = 47 AND cpm.IdMes = @mesFactor   AND cp.IdAnio = @anioIDFactor
								AND CP.IdRegimenLaboral = @RegimenLaboral


						  SELECT @ONP = sum( pp.Calculo)*(@factorEvaluarONP/100)  FROM ERP.ConceptoPorcentaje cp
								INNER JOIN ERP.ConceptoPorcentajeMes cpm ON cp.ID = cpm.IDCONCEPTOPORCENTAJE
								INNER JOIN ERP.ConceptoPorcentajeMesDetalle cpmd ON cpm.ID = cpmd.IdConceptoPorcentajeMes
								INNER JOIN erp.PlanillaPago pp ON pp.IdConcepto = cpmd.IdConcepto
								WHERE cpm.IdMes = @mesFactor   AND cp.IdAnio = @anioIDFactor AND cp.IdConcepto =47 AND pp.IdPlanillaCabecera = @IdPlanillaCabecera
								AND CP.IdRegimenLaboral = @RegimenLaboral
					--	INSERT ERP.AAAA( CODIGO,VALOR)VALUES('@@factorEvaluarONP', CAST(@factorEvaluarONP AS VARCHAR(200)))
					--	INSERT ERP.AAAA( CODIGO,VALOR)VALUES('@ONP', CAST(@ONP AS VARCHAR(200)))

						IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 47  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
						BEGIN
				--		INSERT ERP.AAAA( CODIGO,VALOR)VALUES('PROCESO', 'UPDATE')
							UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@ONP
							 WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 47
						END
						ELSE

						BEGIN
					--	   INSERT ERP.AAAA( CODIGO,VALOR)VALUES('PROCESO', 'INSERT')
							INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,47,0, @ONP)
						END
		END

				---------------------------------------------------------------------------------------------------------------
		-- __              ___ _   _  ___        ___       _   _   _ ___ _  __     _   _  __  _      _     ___ _   __ 
		--(_  | | |\/|  /\  | / \ |_)  |   /\     |  |\/| |_) / \ |_) | |_ (_   / | \ |_ (_  /  | | |_ |\ | | / \ (_  
		--__) |_| |  | /--\ | \_/ | \ _|_ /--\   _|_ |  | |   \_/ | \ | |_ __) /  |_/ |_ __) \_ |_| |_ | \| | \_/ __) 
		---------------------------------------------------------------------------------------------------------------                                                                                                             
		-- 1 ingresos        2   descuento       3 aportaciones 
		-- 87 total ingreso  88 total descuento  89 total aporte
		 -- IMPORTES ---   




		 DECLARE @SumaTotalIMPORTESt decimal(18,6) =0  
		 SELECT  @SumaTotalIMPORTESt= sum(Calculo) 
			FROM ERP.DatoLaboralDetalle dld     
			INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
			INNER JOIN ERP.PlanillaCabecera pc ON dld.ID = pc.IdDatoLaboralDetalle
			INNER JOIN erp.PlanillaPago pp ON pc.id = pp.IdPlanillaCabecera
			INNER JOIN ERP.Concepto c ON c.ID = pp.IdConcepto
			WHERE 
				dld.FechaInicio<= @FechaFinNomina  AND (dld.FechaFin >=@FechaInicioNomina OR dld.FechaFin IS NULL) 
				AND c.IdTipoConcepto = 1 AND pp.IdPlanillaCabecera = @IdPlanillaCabecera

						IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 87  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
						BEGIN
							UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@SumaTotalIMPORTESt
							 WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 87
						END
						ELSE
						BEGIN
							INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,87,0, @SumaTotalIMPORTESt)
						END


		 DECLARE @SumaTotalDESCUENTOSt decimal(18,6) =0 
		 SELECT  @SumaTotalDESCUENTOSt= sum(Calculo) 
			FROM ERP.DatoLaboralDetalle dld     
			INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
			INNER JOIN ERP.PlanillaCabecera pc ON dld.ID = pc.IdDatoLaboralDetalle
			INNER JOIN erp.PlanillaPago pp ON pc.id = pp.IdPlanillaCabecera
			INNER JOIN ERP.Concepto c ON c.ID = pp.IdConcepto
			WHERE 
				dld.FechaInicio<= @FechaFinNomina  AND (dld.FechaFin >=@FechaInicioNomina OR dld.FechaFin IS NULL) 
				AND c.IdTipoConcepto = 2 AND pp.IdPlanillaCabecera = @IdPlanillaCabecera

						IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 88  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
						BEGIN
							UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@SumaTotalDESCUENTOSt
							 WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 88
						END
						ELSE
						BEGIN
							INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,88,0, @SumaTotalDESCUENTOSt)
						END

		 DECLARE @SumaTotalAPORTACIONESt decimal(18,6) =0 
		 SELECT  @SumaTotalAPORTACIONESt= sum(Calculo) 
			FROM ERP.DatoLaboralDetalle dld     
			INNER JOIN ERP.DatoLaboral DL ON DLD.IdDatoLaboral = DL.ID
			INNER JOIN ERP.PlanillaCabecera pc ON dld.ID = pc.IdDatoLaboralDetalle
			INNER JOIN erp.PlanillaPago pp ON pc.id = pp.IdPlanillaCabecera
			INNER JOIN ERP.Concepto c ON c.ID = pp.IdConcepto
			WHERE 
				dld.FechaInicio<= @FechaFinNomina  AND (dld.FechaFin >=@FechaInicioNomina OR dld.FechaFin IS NULL) 
				AND c.IdTipoConcepto = 3 AND pp.IdPlanillaCabecera = @IdPlanillaCabecera

						IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 89  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
						BEGIN
							UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@SumaTotalAPORTACIONESt
							 WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 89
						END
						ELSE
						BEGIN
							INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,89,0, @SumaTotalAPORTACIONESt)
						END


--	NETO A PAGAR 90
            DECLARE @NetoPagar decimal(18,6)=0
			SET @NetoPagar = @SumaTotalAPORTACIONESt-@SumaTotalDESCUENTOSt
				IF EXISTS (SELECT pp.ID FROM ERP.PlanillaPago pp WHERE pp.IdConcepto = 89  AND pp.IdPlanillaCabecera =@IdPlanillaCabecera)
						BEGIN
							UPDATE ERP.PlanillaPago   SET ERP.PlanillaPago.Calculo =@NetoPagar
							WHERE ERP.PlanillaPago.IdPlanillaCabecera = @IdPlanillaCabecera AND  ERP.PlanillaPago.IdConcepto = 90


						END
						ELSE
						BEGIN
							INSERT ERP.PlanillaPago (IdPlanillaCabecera,IdConcepto,SueldoMinimo, Calculo ) VALUES ( @IdPlanillaCabecera,90,0, @NetoPagar)
						END


END