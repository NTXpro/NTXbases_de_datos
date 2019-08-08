﻿
CREATE PROC [ERP].[Usp_Ins_Banco]
@IdBanco			INT OUT,
@IdEntidad				INT OUT,
@CodigoSunat			CHAR(2),
@IdTipoPersona			INT,
@IdTipoDocumento		INT,
@NumeroDocumento		VARCHAR(20),
@NombreCompleto			VARCHAR(50),
@UsuarioModifico		VARCHAR(250),
@UsuarioRegistro		VARCHAR(250),
@RazonSocial			VARCHAR(250),
@Nombre					VARCHAR(50),
@ApellidoPaterno		VARCHAR(50),
@ApellidoMaterno		VARCHAR(50),
@IdSexo					INT,
@IdCondicionSunat		INT,
@IdEstadoContribuyente	INT,
@EstadoSunat			BIT,
@IdTipoEstablecimiento	INT,
@NombreEstablecimiento	VARCHAR(50),
@IdVia					INT,
@NombreVia				VARCHAR(50),
@NumeroVia				VARCHAR(4),
@Interior				VARCHAR(4),
@IdZona					INT,
@NombreZona				VARCHAR(50),
@Referencia				VARCHAR(50),
@Sector					VARCHAR(20),
@Grupo					VARCHAR(20),
@Manzana				VARCHAR(20),
@Lote					VARCHAR(20),
@Kilometro				VARCHAR(20),
@Direccion				VARCHAR(250),
@IdPais					INT,
@IdUbigeo				INT,
@FlagBorrador			BIT,
@FlagBorradorEntidad	BIT,
@FlagSunat				BIT,
@FlagTrabajador			BIT,
@FechaNacimiento		DATETIME,
@IdVia2					INT,
@IdZona2				INT,
@IdPais2				INT,
@IdUbigeo2				INT,
@NombreEstablecimiento2	VARCHAR(250),
@Direccion2				VARCHAR(250),
@NombreVia2				VARCHAR(250),
@NumeroVia2				VARCHAR(250),
@Interior2				VARCHAR(250),
@NombreZona2			VARCHAR(250),
@Referencia2			VARCHAR(250),
@Sector2				VARCHAR(250),
@Grupo2					VARCHAR(250),
@Manzana2				VARCHAR(250),
@Lote2					VARCHAR(250),
@Kilometro2				VARCHAR(250),
@IdEstadoCivil			VARCHAR(250),
@IdCentroAsistencial	INT
AS
BEGIN

		IF @IdEntidad = 0
			BEGIN
				EXEC [ERP].[Usp_Ins_Entidad] @IdEntidad OUT,				
											 @IdTipoPersona,			
											 @IdTipoDocumento,		
											 @NumeroDocumento,	
											 @UsuarioRegistro,	
											 @NombreCompleto,			
											 @RazonSocial,			
											 @Nombre,					
											 @ApellidoPaterno,		
											 @ApellidoMaterno,	
											 @IdSexo,					
											 @IdCondicionSunat,	
											 @IdEstadoContribuyente,	
											 @EstadoSunat,			
											 @IdTipoEstablecimiento,	
											 @NombreEstablecimiento,	
											 @IdVia,					
											 @NombreVia,				
											 @NumeroVia,				
											 @Interior,				
											 @IdZona,					
											 @NombreZona,				
											 @Referencia,
											 @Sector,
											 @Grupo,
											 @Manzana,
											 @Lote,
											 @Kilometro,					
											 @Direccion,
											 @IdPais,				
											 @IdUbigeo,				
											 @FlagBorradorEntidad,
											 @FlagTrabajador,			
											 @FechaNacimiento,	
											 @IdVia2,					
											 @IdZona2,			
											 @IdPais2,				
											 @IdUbigeo2,				
											 @NombreEstablecimiento2,	
											 @Direccion2,				
											 @NombreVia2,				
											 @NumeroVia2,				
											 @Interior2,			
											 @NombreZona2,			
											 @Referencia2,			
											 @Sector2,				
											 @Grupo2,					
											 @Manzana2,				
											 @Lote2,					
											 @Kilometro2,				
											 @IdEstadoCivil,
											 @IdCentroAsistencial				

			END
		ELSE
			BEGIN
				EXEC [ERP].[Usp_Upd_Entidad]@IdEntidad,			
											@IdTipoPersona,		
											@IdTipoDocumento,		
											@NumeroDocumento,		
											@NombreCompleto,
											@UsuarioModifico,		
											@RazonSocial,			
											@Nombre,				
											@ApellidoPaterno,		
											@ApellidoMaterno,		
											@IdSexo,				
											@IdCondicionSunat,	
											@IdEstadoContribuyente,	
											@EstadoSunat,			
											@IdTipoEstablecimiento,
											@NombreEstablecimiento,
											@IdVia,				
											@NombreVia,			
											@NumeroVia,			
											@Interior,				
											@IdZona,				
											@NombreZona,			
											@Referencia,
											@Sector,
											@Grupo,
											@Manzana,
											@Lote,
											@Kilometro,				
											@Direccion,
											@IdPais,			
											@IdUbigeo,				
											@FlagBorradorEntidad,
											@FlagTrabajador,			
											 @FechaNacimiento,	
											 @IdVia2,					
											 @IdZona2,			
											 @IdPais2,				
											 @IdUbigeo2,				
											 @NombreEstablecimiento2,	
											 @Direccion2,				
											 @NombreVia2,				
											 @NumeroVia2,				
											 @Interior2,			
											 @NombreZona2,			
											 @Referencia2,			
											 @Sector2,				
											 @Grupo2,					
											 @Manzana2,				
											 @Lote2,					
											 @Kilometro2,				
											 @IdEstadoCivil,
											 @IdCentroAsistencial				
			END

		INSERT INTO [PLE].[T3Banco](IdEntidad,CodigoSunat,UsuarioRegistro,FechaRegistro,UsuarioModifico,FechaModificado,FlagSunat,FlagBorrador,Flag)
		VALUES(@IdEntidad,@CodigoSunat, @UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@FlagSunat,@FlagBorrador, 1)

		SET @IdBanco = (SELECT CAST(SCOPE_IDENTITY() AS INT));

END
