CREATE PROC [ERP].[Usp_Ins_MasivoTrabajador]
--------------------------------------------------------
-----------------Planilla Cabecera ----------------------
--------------------------------------------------------
@ApellidoPaterno VARCHAR(150),
@ApellidoMaterno VARCHAR(150),
@Nombre VARCHAR(150),
@NumeroDocumento VARCHAR(20),
@Date1 VARCHAR(50),--fecha--formato que recibe-dd/mm/yyy
@IdSexo INT,
@IdEstadoCivil INT,
@FlagAsignacionFamiliar bit,
@FlagPersonaDiscapacidad bit,
@IdUbigeo VARCHAR(250),
@Direccion VARCHAR(250),
@FInicio VARCHAR(50),
@IdBanco int,
@NumeroCuenta VARCHAR(50),
@Sueldo VARCHAR(20),
@IdRegimenPensionario INT ,
@TipoComision INT ,
@CUSPP VARCHAR(20),
@FechaCese VARCHAR(50)--fecha--formato que recibe-dd/mm/yyy


as
------------------ TRABAJADOR------------------------
DECLARE @IdEmpresa INT=1
DECLARE @NombreImagen VARCHAR(500)=NULL
DECLARE @Imagen VARBINARY(MAX)=NULL
DECLARE @UsuarioRegistro VARCHAR(250)='NTX PRO OBRERO'
DECLARE @FechaRegistro DATETIME='2019-01-01 00:00:00.000'
------------------ PERSONA------------------------
DECLARE @FechaNacimiento DATETIME=(SELECT CONVERT(VARCHAR(10), CONVERT(date, @Date1, 105), 23) )
DECLARE @FechaInicio DATETIME=(SELECT CONVERT(VARCHAR(10), CONVERT(date, @FInicio, 105), 23) )

DECLARE @FechaCeseParm DATETIME

DECLARE @IdPais INT=198  
DECLARE @IdCentroAsistencial INT=NULL
DECLARE @IdNivelEducativo INT=5
------------------ ENTIDAD------------------------
DECLARE @IdTipoPersona INT=1
DECLARE @IdCondicionSunat INT=2
DECLARE @EstadoSunat bit=0
DECLARE @IdEstadoContribuyente INT=12
------------------ ENTIDAD TIPO DOCUMENTO
--DECLARE @NumeroDocumento VARCHAR(20)='44444'
DECLARE @IdTipoDocumento INT=2
----------------- ESTABLECIMIENTO
DECLARE @IdEntidad INT = 0
DECLARE @Nombreen VARCHAR(250)='DOMICILIO FISCAL'
--DECLARE @Direccion VARCHAR(250)='Jr rvirus'
DECLARE @IdTipoEstablecimiento  INT=1
----------------- PLANILLA MAESTRO
DECLARE @IdPlanilla INT =3;
----------------- RETORNO
DECLARE @RETORNO VARCHAR(MAX);

BEGIN
------------------------Carga La Cabezera de Planilla-----------------------------------
	SET QUERY_GOVERNOR_COST_LIMIT 90000
BEGIN TRANSACTION
BEGIN TRY


	DECLARE @ID INT;
	DECLARE @EXISTE_ENTIDAD INT = (SELECT COUNT(1) FROM [ERP].[Entidad] E
									INNER JOIN ERP.EntidadTipoDocumento ETD ON E.ID = ETD.IdEntidad
									INNER JOIN ERP.Trabajador T ON E.ID = T.IdEntidad
									WHERE ETD.NumeroDocumento = @NumeroDocumento AND 
										  ETD.IdEntidad = @IdEntidad)

	IF(@IdEntidad = 0)
	BEGIN
			INSERT INTO [ERP].[Entidad]
				([IdTipoPersona]
				,[Nombre]
				,[IdCondicionSunat]
				,[EstadoSunat]
				,[IdEstadoContribuyente]
				,[UsuarioRegistro]
				,[FechaRegistro]
				,[FlagBorrador]
				,[Flag])
			VALUES
				(@IdTipoPersona,
				CONCAT(@ApellidoPaterno, ' ', @ApellidoMaterno, ' ', @Nombre),
				@IdCondicionSunat,
				@EstadoSunat,
				@IdEstadoContribuyente,
				@UsuarioRegistro,
				@FechaRegistro,
				0,
				1)

			SET @IdEntidad = CAST(SCOPE_IDENTITY() AS INT)

			INSERT INTO [ERP].[EntidadTipoDocumento]
				([IdEntidad]
				,[IdTipoDocumento]
				,[NumeroDocumento])
			VALUES
				(@IdEntidad,
				@IdTipoDocumento,
				@NumeroDocumento);

			INSERT INTO [ERP].[Persona]
				([IdEntidad]
				,[IdSexo]
				,[ApellidoPaterno]
				,[ApellidoMaterno]
				,[Nombre]
				,[FechaNacimiento]
				,[IdPais]
				,[IdEstadoCivil]
				,[IdNivelEducativo]
				,[IdCentroAsistencial])
			VALUES
				(@IdEntidad,
				@IdSexo,
				@ApellidoPaterno,
				@ApellidoMaterno,
				@Nombre,
				@FechaNacimiento,
				@IdPais,
				@IdEstadoCivil,
				@IdNivelEducativo,
				@IdCentroAsistencial)

				INSERT INTO [ERP].[Establecimiento]
				([IdEntidad]
				,[Nombre]
				,[Direccion]
				,[IdTipoEstablecimiento]
				,[IdUbigeo]
				,[UsuarioRegistro]
				,[FechaRegistro]
				,[FlagSistema]
				,[FlagBorrador]
				,[Flag])
			VALUES
				(@IdEntidad,
				@Nombreen,
				@Direccion,
				@IdTipoEstablecimiento,
				@IdUbigeo,
		        @UsuarioRegistro,
				@FechaRegistro,
				0,
				0,
				1)

		
			INSERT INTO [ERP].[Trabajador]
				([IdEntidad]
				,[IdEmpresa]
				,[NombreImagen]
				,[Imagen]
				,[UsuarioRegistro]
				,[FechaRegistro]
				,[FlagBorrador]
				,[Flag])
			VALUES
				(@IdEntidad,
				@IdEmpresa,
				@NombreImagen,
				@Imagen,
				@UsuarioRegistro,
				@FechaRegistro,
				0,
				1)

			SET @ID = CAST(SCOPE_IDENTITY() AS INT);
			
			
			
			
	END 
	-----
-------------------------------------------------Dato laboral------------------------------------------------




-------------Buscamos IdTrabajdor--------------------------------

DECLARE @IdTrabajador VARCHAR(20)=(SELECT t.ID FROM ERP.Trabajador t
									INNER JOIN ERP.Entidad e  
									ON T.IdEntidad =E.ID
									INNER JOIN ERP.EntidadTipoDocumento etd
									ON e.ID = etd.IdEntidad
									WHERE etd.NumeroDocumento =@NumeroDocumento)

IF(@FechaCese ='')
BEGIN

	INSERT INTO [ERP].[DatoLaboral]
									(IdEmpresa
									,IdTrabajador
									,FechaInicio
									,UsuarioRegistro
									,FechaRegistro
									,FlagAsignacionFamiliar
									) 
									VALUES
									(
									@IdEmpresa,
									@IdTrabajador,
									@FechaInicio,
									@UsuarioRegistro,
									@FechaRegistro,
						   			@FlagAsignacionFamiliar
									)
END
ELSE
BEGIN
SET @FechaCeseParm=(SELECT CONVERT(VARCHAR(10), CONVERT(date, @FechaCese, 105), 23) )
INSERT INTO [ERP].[DatoLaboral]
									(IdEmpresa
									,IdTrabajador
									,FechaInicio
									,UsuarioRegistro
									,FechaRegistro
									,FlagAsignacionFamiliar
									,FechaCese
									,IdMotivoCese
									) 
									VALUES
									(
									@IdEmpresa,
									@IdTrabajador,
									@FechaInicio,
									@UsuarioRegistro,
									@FechaRegistro,
						   			@FlagAsignacionFamiliar,
									@FechaCeseParm,
									2 
									)
END
--------------------------------------------------------------------
	-----SE REGISTRA LA PENSIÓN PARA EL PRIMER DATO LABORAL-----
--------------------------------------------------------------------
           DECLARE @IdPension INT = 0

				EXEC [ERP].[Usp_Ins_Pension] 
				@IdPension OUT, 
				@IdTrabajador, 
				@IdRegimenPensionario, 
				@TipoComision, 
				@IdEmpresa, 
				@FechaInicio, 
				@CUSPP
				
			

--------------------------------------------------------------------
	-----SE REGISTRA LA PENSIÓN PARA EL PRIMER DATO LABORAL-----
--------------------------------------------------------------------
			DECLARE @IdSalud INT = 0;
			DECLARE @IdRegimenSalud INT = 5;
			DECLARE @IdPrestadoraDeSalud INT = 0;
			
-------------Buscamos DatoLaboral--------------------------------

DECLARE @IdDatoLaboral VARCHAR(20)=(SELECT  dl.ID FROM  ERP.DatoLaboral dl 
									WHERE dl.IdTrabajador=@IdTrabajador)
									

			INSERT INTO ERP.DatoLaboralSalud(
			IdDatoLaboral,
			IdEmpresa,
			IdRegimenSalud,
			IdEntidadPrestadoraDeSalud,
			FechaInicio)
		VALUES(
			@IdDatoLaboral,
			@IdEmpresa,
			@IdRegimenSalud,
			IIF(@IdPrestadoraDeSalud = 0, NULL, @IdPrestadoraDeSalud),
			@FechaInicio)

--------------------------------------------------------------------------------
	---SE REGISTRA LA PENSIÓN PARA EL PRIMER DATO LABORAL  DETALLADO -----
-------------------------------------------------------------------------------

                      DECLARE @IdRegimenLaboral INT =19;  --  AGRARIO LEY 27360
					  DECLARE @IdTipoTrabajador INT =2;   --  DE PLAME.T8TipoTrabajador
					  DECLARE @IdPuesto INT =  43; -- 4582 OBRERO AGRICOLA, AYUDANTE  DE plame.T10Ocupacion
					  DECLARE @HoraBase INT = 96;
					  DECLARE @IdTipoSueldo INT = 4;
					  DECLARE @IdCategoriaDatoLaboral INT  =1;
					  
					  DECLARE @IdCategoriaOcupacional INT =2; --OBRERO  DE PLAME.T24CategoriaOcupacional
					  DECLARE @FlagJornadaTrabajoMaxima INT =0;
					  DECLARE @FlagJornadaAtipica INT =0;
					  DECLARE @FlagJornadaTrabajoHorarioNocturno INT =0;
					  DECLARE @IdSituacionEspecialTrabajador INT =1;
					  DECLARE @FlagSindicalizado INT =0;
					  DECLARE @IdSituacionTrabajador INT =2;  -- DE PLAME.T15SituacionTrabajador
				
				

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
											VALUES
												(
											    @IdDatoLaboral
											  ,@IdRegimenLaboral
											  ,@IdTipoTrabajador
											  ,@IdPuesto
											  ,@IdTipoSueldo
											  ,@Sueldo
											  ,@HoraBase
											  ,@FechaInicio
											  ,@IdCategoriaDatoLaboral
											  ,@IdPlanilla
											  ,@IdCategoriaOcupacional
											  ,@FlagJornadaTrabajoMaxima
											  ,@FlagJornadaAtipica
											  ,@FlagJornadaTrabajoHorarioNocturno
											  ,@IdSituacionEspecialTrabajador
											  ,@FlagSindicalizado
											  ,@IdSituacionTrabajador
											  ,@FlagPersonaDiscapacidad
											  ,@UsuarioRegistro
											  ,@FechaRegistro
										)
									
										DECLARE @IdTipoCuenta INT = 3;
										DECLARE @NumeroCuentaInterbancario  VARCHAR(50) = NULL
										DECLARE @Fecha datetime = '2019-01-01 00:00:00.000'
										DECLARE @FechaActual datetime ='2019-01-01 00:00:00.000'

									INSERT INTO ERP.TrabajadorCuenta(
								   IdEmpresa
								  ,IdTrabajador
								  ,IdBanco
								  ,IdTipoCuenta
								  ,Fecha
								  ,NumeroCuenta
								  ,NumeroCuentaInterbancario
								  ,FechaRegistro
								  ,UsuarioRegistro
								)VALUES(
								 @IdEmpresa
								  ,@IdTrabajador
								  ,@IdBanco
								  ,@IdTipoCuenta
								  ,@Fecha
								  ,@NumeroCuenta
								  ,@NumeroCuentaInterbancario
								  ,@FechaActual
								  ,@UsuarioRegistro
								)

END TRY
BEGIN CATCH 
   SELECT @RETORNO ='ERROR: Nro Documento: '+ @NumeroDocumento + ', ErrorNro: '+CAST(ERROR_NUMBER() AS VARCHAR(50)) +', Linea: '+CAST(ERROR_LINE() AS VARCHAR(50)) +', Desc: ' + ERROR_MESSAGE()
       
   WHILE(@@trancount > 0)
   BEGIN
      ROLLBACK TRANSACTION
   END
end catch
if (@@trancount <> 0)
begin
   COMMIT TRANSACTION;
   SELECT @RETORNO = 'OK'
end
select @RETORNO 

END