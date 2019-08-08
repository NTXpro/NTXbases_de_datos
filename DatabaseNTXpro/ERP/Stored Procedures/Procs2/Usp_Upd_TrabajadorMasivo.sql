CREATE PROC [ERP].[Usp_Upd_TrabajadorMasivo]
------------------ TRABAJADOR
@ApellidoPaterno VARCHAR(150),
@ApellidoMaterno VARCHAR(150),
@Nombre VARCHAR(150),
@NumeroDocumento VARCHAR(20),
@Date1 VARCHAR(50),--fecha--formato que recibe-dd/mm/yyy
@IdSexo INT,
@IdEstadoCivil INT

AS
------------------ TRABAJADOR------------------------
DECLARE @IdEmpresa INT=1
DECLARE @NombreImagen VARCHAR(500)=NULL
DECLARE @Imagen VARBINARY(MAX)=NULL
DECLARE @UsuarioRegistro VARCHAR(250)='NTX PRO OBRERO'
DECLARE @FechaRegistro DATETIME='2019-01-01 00:00:00.000'
------------------ PERSONA------------------------
DECLARE @FechaNacimiento DATETIME=(SELECT CONVERT(VARCHAR(10), CONVERT(date, @Date1, 105), 23) )
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

DECLARE @Nombreen VARCHAR(250)='DOMICILIO FISCAL'
--DECLARE @Direccion VARCHAR(250)='Jr rvirus'
DECLARE @IdTipoEstablecimiento  INT=1
----------------- PLANILLA MAESTRO
DECLARE @IdPlanilla INT =3
BEGIN

    DECLARE @IdEntidad INT = (SELECT IdEntidad FROM ERP.EntidadTipoDocumento  
	                         WHERE NumeroDocumento = @NumeroDocumento )   
       
	

		
			UPDATE [ERP].[Entidad] SET 
				[IdTipoPersona] = @IdTipoPersona,
				[Nombre] = CONCAT(@ApellidoPaterno, ' ', @ApellidoMaterno, ' ', @Nombre),
				[IdCondicionSunat] = @IdCondicionSunat,
				[EstadoSunat] = @EstadoSunat,
				[IdEstadoContribuyente] = @IdEstadoContribuyente,
				[UsuarioModifico] = @UsuarioRegistro,
				[FechaModificado] = @FechaRegistro
			WHERE ID = @IdEntidad

			UPDATE [ERP].[EntidadTipoDocumento] SET 
				[IdTipoDocumento] = @IdTipoDocumento,
				[NumeroDocumento] = @NumeroDocumento
			WHERE IdEntidad = @IdEntidad

			UPDATE [ERP].[Persona] SET 
				[IdSexo] = @IdSexo,
				[ApellidoPaterno] = @ApellidoPaterno,
				[ApellidoMaterno] = @ApellidoMaterno,
				[Nombre] = @Nombre,
				[FechaNacimiento] = @FechaNacimiento,
				[IdPais] = @IdPais,
				[IdEstadoCivil] = @IdEstadoCivil,
				[IdNivelEducativo] = @IdNivelEducativo,
				[IdCentroAsistencial] = @IdCentroAsistencial
			WHERE IdEntidad = @IdEntidad


	
END