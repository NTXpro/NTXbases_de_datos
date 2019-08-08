CREATE PROC [ERP].[Usp_Upd_Empresa]
@IdTipoActividad		INT,
@IdEmpresa				INT,
@IdEntidad				INT out,
@IdTipoPersona			INT,
@IdTipoDocumento		INT,
@NumeroDocumento		VARCHAR(20),
@NombreCompleto			VARCHAR(250),
@RazonSocial			VARCHAR(250),
@Nombre					VARCHAR(50),
@ApellidoPaterno		VARCHAR(50),
@ApellidoMaterno		VARCHAR(50),
@IdSexo					INT,
@IdCondicionSunat		INT,
@IdEstadoContribuyente	INT,
@EstadoSunat			BIT,
@IdTipoEstablecimiento	INT,
@NombreEstablecimiento	VARCHAR(250),
@IdVia					INT,
@NombreVia				VARCHAR(250),
@NumeroVia				VARCHAR(4),
@Interior				VARCHAR(4),
@IdZona					INT,
@NombreZona				VARCHAR(250),
@Referencia				VARCHAR(250),
@Sector					VARCHAR(20),
@Grupo					VARCHAR(20),
@Manzana				VARCHAR(20),
@Lote					VARCHAR(20),
@Kilometro				VARCHAR(20),
@Direccion				VARCHAR(250),
@UsuarioRegistro		VARCHAR(250),
@NombreImagen			VARCHAR(250),
@Imagen					VARBINARY(MAX),
@NumeroResolucion		VARCHAR(50),
@Correo					VARCHAR(250),
@Web					VARCHAR(250),
@Telefono				VARCHAR(50),
@Celular				VARCHAR(50),
@IdPais					INT,
@IdUbigeo				INT,
@FlagBorrador			BIT,
@FlagBorradorEntidad	BIT,
@IdEmpresaPlantilla		INT,
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
@IdCentroAsistencial	INT,
@BuenContribuyente		BIT,
@ResolucionBuenContribuyente VARCHAR(100)
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
											 @Sector	,	
											 @Grupo	,	
											 @Manzana,	
											 @Lote	,	
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
											 @IdEstadoCivil	,
											 @IdCentroAsistencial,
											 @BuenContribuyente,
											 @ResolucionBuenContribuyente

			END
		ELSE
			BEGIN
				EXEC [ERP].[Usp_Upd_Entidad] @IdEntidad,			
											@IdTipoPersona,		
											@IdTipoDocumento,		
											@NumeroDocumento,		
											@NombreCompleto,
											@UsuarioRegistro,		
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
											@Sector	,	
											@Grupo	,	
											@Manzana,	
											@Lote	,	
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
											 @IdCentroAsistencial,
											 @BuenContribuyente,
											 @ResolucionBuenContribuyente

			END

	UPDATE ERP.Empresa 
	SET IdTipoActividad = @IdTipoActividad, 
		IdEntidad = @IdEntidad, 
		FlagBorrador = @FlagBorrador, 
		UsuarioModifico = @UsuarioRegistro, 
		FechaModificado = DATEADD(HOUR, 3, GETDATE()), 
		Imagen = @Imagen, 
		NombreImagen = @NombreImagen, 
		NumeroResolucion = @NumeroResolucion, 
		Correo= @Correo, 
		Web = @Web, 
		Telefono = @Telefono, 
		Celular = @Celular 
	WHERE ID = @IdEmpresa
	
	DECLARE @FlagPlantillaEmpresa BIT = (SELECT ISNULL(FlagPlantillaEmpresa,0) FROM ERP.Empresa WHERE ID = @IdEmpresa)
	DECLARE @FlagPrincipal BIT = (SELECT ISNULL(FlagPrincipal,0) FROM ERP.Empresa WHERE ID = @IdEmpresa)

	IF @FlagBorrador = 0 AND @FlagPlantillaEmpresa = 0 AND @FlagPrincipal = 0
	BEGIN
		UPDATE ERP.Empresa SET  FlagPlantillaEmpresa = CAST(1 AS BIT) WHERE ID = @IdEmpresa
		
		EXEC [ERP].[Usp_Ins_ClienteVarios_Empresa] @IdEmpresa

		EXEC [ERP].[Usp_Ins_Parametro_Empresa] @IdEmpresa,@IdEmpresaPlantilla
		
		EXEC [ERP].[Usp_Ins_ListaPrecio_Empresa] @IdEmpresa

		EXEC [ERP].[Usp_Ins_Almacen_Empresa] @IdEmpresa

		EXEC ERP.Usp_Ins_Grado_Empresa @IdEmpresa,@IdEmpresaPlantilla

		EXEC [ERP].[Usp_Ins_PlanCuenta_Empresa] @IdEmpresa,@IdEmpresaPlantilla

		EXEC ERP.Usp_Ins_PlanCuentaDestino_Empresa @IdEmpresa,@IdEmpresaPlantilla

		EXEC [ERP].[Usp_Ins_Acceso_Empresa] @IdEmpresa

		EXEC [ERP].[Usp_Ins_TipoComprobantePlanCuenta_Empresa] @IdEmpresa,@IdEmpresaPlantilla

		EXEC [ERP].[Usp_Ins_Operacion_Empresa] @IdEmpresa,@IdEmpresaPlantilla

		EXEC [ERP].[Usp_Ins_Estructura_By_IdEmpresa] @IdEmpresaPlantilla, @IdEmpresa
	END

END