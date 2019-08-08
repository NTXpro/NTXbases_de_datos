

CREATE PROCEDURE [ERP].[Usp_Ins_DatoLaboral]
@XMLDatoLaboral	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		DECLARE @IdDatoLaboralDetalle INT;
		DECLARE @IdDatoLaboral INT = ISNULL((SELECT T.N.value('ID[1]','INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N)),0);
		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
		DECLARE @FechaInicioDetalle DATETIME= (SELECT T.N.value('FechaInicio[1]','DATETIME') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboralDetalle')	AS T(N));
		
		IF @IdDatoLaboral != 0
		BEGIN
		DECLARE @UltimaFechaDatoLaboralDetalle DATETIME = (SELECT MAX(FechaInicio) FROM ERP.DatoLaboralDetalle WHERE IdDatoLaboral = @IdDatoLaboral)
		--IF CAST(@FechaInicioDetalle AS DATE) <= CAST(@UltimaFechaDatoLaboralDetalle AS DATE)
		IF CAST(@FechaActual AS DATE) <= CAST(@UltimaFechaDatoLaboralDetalle AS DATE)
			BEGIN
				SET @IdDatoLaboral = -1 
			END
		END

		IF @IdDatoLaboral = -1
		BEGIN
			SELECT @IdDatoLaboral
		END
		ELSE
		BEGIN
			-----SI NO EXISTE EL DATO LABORAL SE REGISTRA
			--IF @IdDatoLaboral > 0
			--BEGIN
			--	INSERT INTO ERP.DatoLaboral(   IdEmpresa
			--								  ,IdTrabajador
			--								  ,FechaInicio
			--								  ,UsuarioRegistro
			--								  ,FechaRegistro
			--								  ,FlagAsignacionFamiliar
			--								) 
			--	SELECT
			--		T.N.value('IdEmpresa[1]',			'INT')					AS IdEmpresa,
			--		T.N.value('IdTrabajador[1]',			'INT')				AS IdTrabajador,
			--		T.N.value('FechaInicio[1]',			'DATETIME')				AS FechaInicio,
			--		T.N.value('UsuarioRegistro[1]',			'VARCHAR(250)')		AS UsuarioRegistro,
			--		@FechaActual,
			--		T.N.value('FlagAsignacionFamiliar[1]','BIT')				AS FlagAsignacionFamiliar
			--	FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N)
			--	SET @IdDatoLaboral = SCOPE_IDENTITY()
			
			--	-----OBTENCIÓN DE DATOS PARA REGISTROS
			--	DECLARE @IdTrabajador INT = (SELECT T.N.value('IdTrabajador[1]','INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N));
			--	DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N));
			--	DECLARE @FechaInicio DATETIME= (SELECT T.N.value('FechaInicio[1]','DATETIME') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N));

			--	-----SE REGISTRA LA PENSIÓN PARA EL PRIMER DATO LABORAL
			--	DECLARE @IdPension INT = 0;
			--	DECLARE @TipoComision INT = 0;
			--	DECLARE @IdRegimenPensionario INT = 1;
			--	DECLARE @CUSPP VARCHAR(20)= '';
			--	EXEC [ERP].[Usp_Ins_Pension] @IdPension OUT, @IdTrabajador, @IdRegimenPensionario, @TipoComision, @IdEmpresa, @FechaInicio, @CUSPP

			--	-----SE REGISTRA LA SALUD PARA EL PRIMER DATO LABORAL
			--	DECLARE @IdSalud INT = 0;
			--	DECLARE @IdRegimenSalud INT = 1;
			--	DECLARE @IdPrestadoraDeSalud INT = 0;
			--	EXEC [ERP].[Usp_Ins_Salud] @IdSalud OUT, @IdDatoLaboral, @IdEmpresa, @IdRegimenSalud, @IdPrestadoraDeSalud, @FechaInicio
			--END

			-----SE REGISTRA EL DATO LABORAL DETALLE

			INSERT INTO ERP.DatoLaboralDetalle(IdDatoLaboral
											  ,IdRegimenLaboral
											  ,IdTipoTrabajador
											  ,IdPuesto
											  ,IdTipoSueldo
											  ,Sueldo
											  ,HoraBase
											  ,FechaInicio
											  ,IdCategoriaDatoLaboral
											  ,IdPlanilla
											  ,IdCategoriaOcupacional
											  ,FlagJornadaTrabajoMaxima
											  ,FlagJornadaAtipica
											  ,FlagJornadaTrabajoHorarioNocturno
											  ,IdSituacionEspecialTrabajador
											  ,FlagSindicalizado
											  ,IdSituacionTrabajador
											  ,FlagPersonaDiscapacidad
											  ,UsuarioRegistro
											  ,FechaRegistro
											) 
			SELECT
				@IdDatoLaboral												AS IdDatoLaboral,
				T.N.value('IdRegimenLaboral[1]',			'INT')			AS IdRegimenLaboral,
				T.N.value('IdTipoTrabajador[1]',			'INT')			AS IdTipoTrabajador,
				T.N.value('IdPuesto[1]',			'INT')					AS IdPuesto,
				T.N.value('IdTipoSueldo[1]',			'INT')				AS IdTipoSueldo,
				T.N.value('Sueldo[1]',			'DECIMAL(14,5)')			AS Sueldo,
				T.N.value('HoraBase[1]',			'DECIMAL(14,5)')		AS HoraBase,
				T.N.value('FechaInicio[1]',			'DATETIME')				AS FechaInicio,
				T.N.value('IdCategoriaDatoLaboral[1]',			'INT')		AS IdCategoriaDatoLaboral,
				T.N.value('IdPlanilla[1]',			'INT')					AS IdPlanilla,
				T.N.value('IdCategoriaOcupacional[1]',			'INT')		AS IdCategoriaOcupacional,
				T.N.value('FlagJornadaTrabajoMaxima[1]',			'BIT')	AS FlagJornadaTrabajoMaxima,
				T.N.value('FlagJornadaAtipica[1]',			'BIT')			AS FlagJornadaAtipica,
				T.N.value('FlagJornadaTrabajoHorarioNocturno[1]','BIT')		AS FlagJornadaTrabajoHorarioNocturno,
				T.N.value('IdSituacionEspecialTrabajador[1]','INT')			AS IdSituacionEspecialTrabajador,
				T.N.value('FlagSindicalizado[1]',			'BIT')			AS FlagSindicalizado,
				T.N.value('IdSituacionTrabajador[1]',			'INT')		AS IdSituacionTrabajador,
				T.N.value('FlagPersonaDiscapacidad[1]',			'BIT')		AS FlagPersonaDiscapacidad,
				T.N.value('UsuarioRegistro[1]',			'VARCHAR(250)')		AS UsuarioRegistro,
				@FechaActual
			FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboralDetalle')	AS T(N)
			SET @IdDatoLaboralDetalle = SCOPE_IDENTITY()

			----AL REGISTRAR UN CAMBIO DE DATO LABORAL, SE REALIZA EL CIERRE DEL ANTERIOR DATO LABORAL
			DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.DatoLaboralDetalle
							WHERE IdDatoLaboral = @IdDatoLaboral AND ID < @IdDatoLaboralDetalle
							ORDER BY ID DESC);

			UPDATE ERP.DatoLaboralDetalle SET
			--FechaFin = DATEADD(DAY, -1, @FechaInicioDetalle)
			FechaFin = DATEADD(DAY, -1, @FechaActual)
			WHERE ID = @LAST_ID;
			 ----- insertar planilla cabecera
			DECLARE @IdTrabajador INT = (SELECT T.N.value('IdTrabajador[1]','INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N));
			DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N));
			DECLARE @IdPlanilla int = (SELECT T.N.value('IdPlanilla[1]',			'INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboralDetalle')	AS T(N))
			DECLARE @FechaFin DATETIME = null--(SELECT T.N.value('FechaFin[1]','DATETIME') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboralDetalle')	AS T(N))
			DECLARE @FechaInicio DATETIME= (SELECT T.N.value('FechaInicio[1]','DATETIME') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N))
			DECLARE @Anio int = (select YEAR(GETDATE()))
			DECLARE @IdAnio int =(SELECT a.ID FROM Maestro.Anio a WHERE a.Nombre = cast(@Anio AS varchar(10)))
			DECLARE @IdMes int =(SELECT MONTH(GETDATE()))
		--	EXECUTE [ERP].[Usp_Ins_PlanillaCabecera] @IdEmpresa,@IdPlanilla,@IdTrabajador,@FechaInicio,@FechaFin,@IdAnio,@IdMes,@IdDatoLaboralDetalle
		   ------------------------------------------------------------------------------------------
			



			SELECT @IdDatoLaboral
		END
		

		SET NOCOUNT OFF;
END