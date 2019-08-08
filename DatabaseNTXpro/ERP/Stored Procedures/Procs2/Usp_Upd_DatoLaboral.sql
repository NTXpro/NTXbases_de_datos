-----------




------



-----------

-- Stored Procedure

CREATE PROCEDURE [ERP].[Usp_Upd_DatoLaboral]
@XMLDatoLaboral	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		DECLARE @IdDatoLaboral INT = ISNULL((SELECT T.N.value('ID[1]','INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N)),0);
		DECLARE @IdDatoLaboralDetallePrincipal INT = (SELECT TOP 1 MIN(ID) FROM ERP.DatoLaboralDetalle WHERE IdDatoLaboral = @IdDatoLaboral);
		DECLARE @IdDatoLaboralDetalle DATETIME = ISNULL((SELECT T.N.value('ID[1]','INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboralDetalle') AS T(N)),0);
		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
		DECLARE @FechaInicioActual DATETIME = (SELECT FechaInicio FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral);
		-----SI EL DETALLE A MODIFICAR ES EL PRINCIPAL
		IF @IdDatoLaboralDetallePrincipal = @IdDatoLaboralDetalle
		BEGIN
			-----SE MODIFICARA LA FECHA DE CABECERA DEL DATO LABORAL
			UPDATE ERP.DatoLaboral SET FechaInicio = T.N.value('FechaInicio[1]','DATETIME'),
									   FlagAsignacionFamiliar = T.N.value('FlagAsignacionFamiliar[1]','BIT')
			FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N)
			WHERE ID = T.N.value('ID[1]','INT');

			-----OBTENCIÓN DE DATOS PARA REGISTROS
			DECLARE @IdTrabajador INT = (SELECT T.N.value('IdTrabajador[1]','INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N));
			DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N));
			DECLARE @FechaInicio DATETIME= (SELECT T.N.value('FechaInicio[1]','DATETIME') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboral')	AS T(N));

			-----SE MODIFICARA LA PRIMERA PENSION
			DECLARE @IdPension INT = (SELECT ID FROM ERP.TrabajadorPension WHERE IdTrabajador = @IdTrabajador AND CAST(FechaInicio AS DATE) = CAST(@FechaInicioActual AS DATE));
			DECLARE @IdRegimenPensionario INT = 1;
			DECLARE @TipoComision INT = 0;
			DECLARE @CUSPP VARCHAR(20)= '';

			EXEC [ERP].[Usp_Upd_Pension] @IdPension, @IdTrabajador, @IdRegimenPensionario, @TipoComision, @IdEmpresa, @FechaInicio, @CUSPP

			-----SE REGISTRA LA SALUD PARA EL PRIMER DATO LABORAL
			DECLARE @IdSalud INT = (SELECT ID FROM ERP.DatoLaboralSalud WHERE IdDatoLaboral = @IdDatoLaboral AND CAST(FechaInicio AS DATE) = CAST(@FechaInicioActual AS DATE));;
			DECLARE @IdRegimenSalud INT = 1;
			DECLARE @IdPrestadoraDeSalud INT = 0;
		--	EXEC [ERP].[Usp_Upd_Salud] @IdSalud, @IdDatoLaboral, @IdEmpresa, @IdRegimenSalud, @IdPrestadoraDeSalud, @FechaInicio
		    DECLARE @FECHA_INICIO_LABORAL DATETIME = (SELECT FechaInicio FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral);
						IF(@FechaInicio >= @FECHA_INICIO_LABORAL)
						BEGIN
							DECLARE @LAST_ID2 INT = (SELECT TOP 1 ID FROM ERP.DatoLaboralSalud
													WHERE IdEmpresa = @IdEmpresa AND IdDatoLaboral = @IdDatoLaboral AND ID != @IdSalud
													ORDER BY ID DESC);

							UPDATE ERP.DatoLaboralSalud SET 
							IdRegimenSalud = @IdRegimenSalud,
							IdEntidadPrestadoraDeSalud = IIF(@IdPrestadoraDeSalud = 0, NULL, @IdPrestadoraDeSalud),
							FechaInicio = @FechaInicio
							WHERE ID = @IdSalud

							UPDATE ERP.DatoLaboralSalud SET
							FechaFin = DATEADD(DAY, -1, @FechaInicio)
							WHERE ID = @LAST_ID2;

							--SELECT @IdSalud;
						END
		--------------------------------------------------------------------------------------------------------------------------

		END

		-----SE MODIFICA EL DETALLE LABORAL
		UPDATE ERP.DatoLaboralDetalle SET  IdRegimenLaboral = T.N.value('IdRegimenLaboral[1]',			'INT')
										  ,IdTipoTrabajador = T.N.value('IdTipoTrabajador[1]',			'INT')
										  ,IdPuesto = T.N.value('IdPuesto[1]',			'INT')
										  ,IdTipoSueldo = T.N.value('IdTipoSueldo[1]',			'INT')
										  ,Sueldo = T.N.value('Sueldo[1]',			'DECIMAL(14,5)')
										  ,IdEstadoTrabajador = T.N.value('IdEstadoTrabajador[1]',			'INT')
										  ,HoraBase = T.N.value('HoraBase[1]',			'DECIMAL(14,5)')
										  ,FechaInicio = T.N.value('FechaInicio[1]',			'DATETIME')
										  ,IdCategoriaDatoLaboral = T.N.value('IdCategoriaDatoLaboral[1]',			'INT')
										  ,IdPlanilla = T.N.value('IdPlanilla[1]',			'INT')
										  ,IdCategoriaOcupacional = T.N.value('IdCategoriaOcupacional[1]',			'INT')
										  ,FlagJornadaTrabajoMaxima = T.N.value('FlagJornadaTrabajoMaxima[1]',			'BIT')
										  ,FlagJornadaAtipica = T.N.value('FlagJornadaAtipica[1]',			'BIT')
										  ,FlagJornadaTrabajoHorarioNocturno = T.N.value('FlagJornadaTrabajoHorarioNocturno[1]','BIT')
										  ,IdSituacionEspecialTrabajador = T.N.value('IdSituacionEspecialTrabajador[1]','INT')
										  ,FlagSindicalizado = T.N.value('FlagSindicalizado[1]',			'BIT')
										  ,IdSituacionTrabajador = T.N.value('IdSituacionTrabajador[1]',			'INT')
										  ,FlagPersonaDiscapacidad = T.N.value('FlagPersonaDiscapacidad[1]',			'BIT')
										  ,UsuarioModifico = T.N.value('UsuarioRegistro[1]',			'VARCHAR(250)')
										  ,FechaModifico = @FechaActual
		FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboralDetalle') AS T(N)
		WHERE ID = T.N.value('ID[1]','INT')

		----AL REGISTRAR UN CAMBIO DE DATO LABORAL, SE REALIZA EL CIERRE DEL ANTERIOR DATO LABORAL
		DECLARE @FechaInicioDetalle DATETIME= (SELECT T.N.value('FechaInicio[1]','DATETIME') FROM @XMLDatoLaboral.nodes('/ArchivoPlanoDatoLaboralDetalle')	AS T(N));
		DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.DatoLaboralDetalle
						WHERE IdDatoLaboral = @IdDatoLaboral AND ID < @IdDatoLaboralDetalle
						ORDER BY ID DESC);

		UPDATE ERP.DatoLaboralDetalle SET
		FechaFin = DATEADD(DAY, -1, @FechaInicioDetalle)
		WHERE ID = @LAST_ID;
		------------------------------------------------------------------------------------------


		SELECT @IdDatoLaboral
		SET NOCOUNT OFF;
END