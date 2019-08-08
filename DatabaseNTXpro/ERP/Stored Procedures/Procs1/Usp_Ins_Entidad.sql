CREATE PROC [ERP].[Usp_Ins_Entidad]
@IdEntidad				INT OUT,
@IdTipoPersona			INT,
@IdTipoDocumento		INT,
@NumeroDocumento		VARCHAR(20),
@UsuarioRegistro		VARCHAR(250),
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
@IdPais					INT,
@IdUbigeo				INT,
@FlagBorradorEntidad	BIT,
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
@BuenContribuyente		BIT = 0,
@ResolucionBuenContribuyente VARCHAR(100) = ''
AS

BEGIN

		INSERT INTO ERP.Entidad(Nombre, UsuarioRegistro, IdTipoPersona,EstadoSunat,IdCondicionSunat,IdEstadoContribuyente,FechaRegistro,FlagBorrador,Flag, BuenContribuyente, ResolucionBuenContribuyente) 
		VALUES(@NombreCompleto, @UsuarioRegistro, @IdTipoPersona,@EstadoSunat,@IdCondicionSunat,@IdEstadoContribuyente,DATEADD(HOUR, 3, GETDATE()),@FlagBorradorEntidad,1, @BuenContribuyente, @ResolucionBuenContribuyente)

		SET @IdEntidad = (SELECT CAST(SCOPE_IDENTITY() AS INT));

		INSERT INTO ERP.EntidadTipoDocumento(IdEntidad,IdTipoDocumento,NumeroDocumento) 
		VALUES (@IdEntidad , @IdTipoDocumento, @NumeroDocumento);

		

		IF (@FlagTrabajador = 1)
			BEGIN
				EXEC ERP.Usp_Ins_Establecimiento @IdEntidad,1/*DOMICILO FISCAL*/,@IdVia,@IdZona, @IdPais,@IdUbigeo,@NombreEstablecimiento,@Direccion,@NombreVia,@NumeroVia,@Interior,@NombreZona,@Referencia,@Sector,@Grupo,@Manzana,@Lote,@Kilometro,0,1
				EXEC ERP.Usp_Ins_Establecimiento @IdEntidad,4/*SUCURSAL*/,@IdVia2,@IdZona2, @IdPais,@IdUbigeo2,@NombreEstablecimiento2,@Direccion2,@NombreVia2,@NumeroVia2,@Interior2,@NombreZona2,@Referencia2,@Sector2,@Grupo2,@Manzana2,@Lote2,@Kilometro2,0,1
			END
		ELSE
			BEGIN
				EXEC ERP.Usp_Ins_Establecimiento @IdEntidad,@IdTipoEstablecimiento,@IdVia,@IdZona, @IdPais,@IdUbigeo,@NombreEstablecimiento,@Direccion,@NombreVia,@NumeroVia,@Interior,@NombreZona,@Referencia,@Sector,@Grupo,@Manzana,@Lote,@Kilometro,0,1
			END


		IF @IdTipoPersona = 1 --== NATURAL
			BEGIN

				EXEC [ERP].[Usp_Ins_Persona] @IdEntidad,@ApellidoPaterno,@ApellidoMaterno,@Nombre,@IdSexo,@IdPais,@IdEstadoCivil,1,@FechaNacimiento

			END
END