CREATE PROC [ERP].[Usp_Upd_Entidad]
@IdEntidad				INT,
@IdTipoPersona			INT,
@IdTipoDocumento		INT,
@NumeroDocumento		VARCHAR(20),
@NombreCompleto			VARCHAR(250),
@UsuarioModifico		VARCHAR(250),
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
@FlagBorrador			BIT,
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
		
		DECLARE @IdTipoPersonaEntidad INT = (SELECT IdTipoPersona FROM ERP.Entidad E WHERE E.ID = @IdEntidad);

		IF(@IdTipoPersonaEntidad = 1 AND  @IdTipoPersona = 2) --== Si se realiza cambio de P.Natural a Juridica
		BEGIN
			DELETE FROM ERP.Persona WHERE IdEntidad = @IdEntidad --== Se elimina el registro de la tabla Persona
		END

		IF (@IdTipoPersona = 1 AND @IdTipoPersonaEntidad = 2) --== Si se realiza cambio de P.Juridica a Natural
		BEGIN

			EXEC [ERP].[Usp_Ins_Persona] @IdEntidad,@ApellidoMaterno,@ApellidoPaterno,@Nombre,@IdSexo,@IdPais,@IdEstadoCivil,@IdCentroAsistencial,@FechaNacimiento --==Se registra en la tabla Persona
		END

		IF(@IdTipoPersona = 1 AND @IdTipoPersonaEntidad = 1) ---== Si es P.Natural se modifica
		BEGIN
			EXEC [ERP].[Usp_Upd_Persona] @IdEntidad, @ApellidoPaterno, @ApellidoMaterno,@Nombre,@IdSexo,@IdPais,@IdEstadoCivil,@IdCentroAsistencial,@FechaNacimiento
		END

		---=== UPDATE ENTIDAD ===---

		UPDATE ERP.Entidad 
		SET	Nombre = @NombreCompleto, 
			UsuarioModifico = @UsuarioModifico,
			IdTipoPersona = @IdTipoPersona,
			IdCondicionSunat = @IdCondicionSunat,
			IdEstadoContribuyente = @IdEstadoContribuyente,
			FlagBorrador = @FlagBorrador,
			FechaModificado = DATEADD(HOUR, 3, GETDATE()),
			BuenContribuyente = @BuenContribuyente,
			ResolucionBuenContribuyente = @ResolucionBuenContribuyente
		WHERE ID = @IdEntidad

		---=== UPDATE ENTIDAD TIPO DOCUMENTO ===---

		UPDATE ERP.EntidadTipoDocumento SET IdTipoDocumento = @IdTipoDocumento,
											NumeroDocumento = @NumeroDocumento
		WHERE IdEntidad = @IdEntidad

		--== UPDATE ESTABLECIMIENTO ===---
		
		IF (@FlagTrabajador = 1)
			BEGIN
				EXEC ERP.Usp_Upd_Establecimiento @IdEntidad,1/*DOMICILO FISCAL*/,@IdVia,@IdZona, @IdPais,@IdUbigeo,@NombreEstablecimiento,@Direccion,@NombreVia,@NumeroVia,@Interior,@NombreZona,@Referencia,@Sector,@Grupo,@Manzana,@Lote,@Kilometro,0,1
				EXEC ERP.Usp_Upd_Establecimiento @IdEntidad,4/*SUCURSAL*/,@IdVia2,@IdZona2, @IdPais,@IdUbigeo2,@NombreEstablecimiento2,@Direccion2,@NombreVia2,@NumeroVia2,@Interior2,@NombreZona2,@Referencia2,@Sector2,@Grupo2,@Manzana2,@Lote2,@Kilometro2,0,1
			END
		ELSE
			BEGIN
				EXEC ERP.Usp_Upd_Establecimiento @IdEntidad,@IdTipoEstablecimiento,@IdVia,@IdZona,@IdPais,@IdUbigeo,@NombreEstablecimiento,@Direccion,@NombreVia,@NumeroVia,@Interior,@NombreZona,@Referencia,@Sector,@Grupo,@Manzana,@Lote,@Kilometro,0,1 
			END
	
END