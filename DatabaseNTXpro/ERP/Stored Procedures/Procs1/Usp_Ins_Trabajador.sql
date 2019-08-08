CREATE PROC [ERP].[Usp_Ins_Trabajador]
------------------ TRABAJADOR
@IdEmpresa INT,
@NombreImagen VARCHAR(500),
@Imagen VARBINARY(MAX),
@UsuarioRegistro VARCHAR(250),
@FechaRegistro DATETIME,
------------------ PERSONA
@IdSexo INT,
@ApellidoPaterno VARCHAR(150),
@ApellidoMaterno VARCHAR(150),
@Nombre VARCHAR(150),
@FechaNacimiento DATETIME,
@IdPais INT,
@IdEstadoCivil INT,
@IdCentroAsistencial INT,
@IdNivelEducativo INT,
------------------ ENTIDAD
@IdTipoPersona INT,
@IdCondicionSunat INT,
@EstadoSunat bit,
@IdEstadoContribuyente INT,
------------------ ENTIDAD TIPO DOCUMENTO
@NumeroDocumento VARCHAR(20),
@IdTipoDocumento INT,
----------------- ESTABLECIMIENTO
@XMLEstablecimiento XML,
@IdEntidad INT
AS
BEGIN

	SET QUERY_GOVERNOR_COST_LIMIT 90000
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
				,[IdVia]
				,[ViaNombre]
				,[ViaNumero]
				,[Interior]
				,[IdZona]
				,[ZonaNombre]
				,[Referencia]
				,[IdUbigeo]
				,[Sector]
				,[Grupo]
				,[Manzana]
				,[Lote]
				,[Kilometro]
				,[IdPais]
				,[UsuarioRegistro]
				,[FechaRegistro]
				,[FlagSistema]
				,[FlagBorrador]
				,[Flag])
			SELECT 
				@IdEntidad,
				T.N.value('Nombre[1]', 'VARCHAR(250)'),
				T.N.value('Direccion[1]', 'VARCHAR(250)'),
				T.N.value('IdTipoEstablecimiento[1]', 'INT'),
				T.N.value('IdVia[1]', 'INT'),
				T.N.value('ViaNombre[1]', 'VARCHAR(250)'),
				T.N.value('ViaNumero[1]', 'VARCHAR(4)'),
				T.N.value('Interior[1]', 'VARCHAR(4)'),
				T.N.value('IdZona[1]', 'INT'),
				T.N.value('ZonaNombre[1]', 'VARCHAR(250)'),
				T.N.value('Referencia[1]', 'VARCHAR(250)'),
				T.N.value('IdUbigeo[1]', 'INT'),
				T.N.value('Sector[1]', 'VARCHAR(20)'),
				T.N.value('Grupo[1]', 'VARCHAR(20)'),
				T.N.value('Manzana[1]', 'VARCHAR(20)'),
				T.N.value('Lote[1]', 'VARCHAR(20)'),
				T.N.value('Kilometro[1]', 'VARCHAR(20)'),
				T.N.value('IdPais[1]', 'INT'),
				@UsuarioRegistro,
				@FechaRegistro,
				0,
				0,
				1
			FROM 
			@XMLEstablecimiento.nodes('/Establecimiento') AS T(N)

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

			SELECT @ID;
	END
	ELSE
	BEGIN
		IF(@EXISTE_ENTIDAD = 0)
		BEGIN
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

			UPDATE E SET
				[E].[Nombre] = T.N.value('Nombre[1]', 'VARCHAR(250)'),
				[E].[Direccion] = T.N.value('Direccion[1]', 'VARCHAR(250)'),
				[E].[IdTipoEstablecimiento] = T.N.value('IdTipoEstablecimiento[1]', 'INT'),
				[E].[IdVia] = T.N.value('IdVia[1]', 'INT'),
				[E].[ViaNombre] = T.N.value('ViaNombre[1]', 'VARCHAR(250)'),
				[E].[ViaNumero] = T.N.value('ViaNumero[1]', 'VARCHAR(4)'),
				[E].[Interior] = T.N.value('Interior[1]', 'VARCHAR(4)'),
				[E].[IdZona] = T.N.value('IdZona[1]', 'INT'),
				[E].[ZonaNombre] = T.N.value('ZonaNombre[1]', 'VARCHAR(250)'),
				[E].[Referencia] = T.N.value('Referencia[1]', 'VARCHAR(250)'),
				[E].[IdUbigeo] = T.N.value('IdUbigeo[1]', 'INT'),
				[E].[Sector] = T.N.value('Sector[1]', 'VARCHAR(20)'),
				[E].[Grupo] = T.N.value('Grupo[1]', 'VARCHAR(20)'),
				[E].[Manzana] = T.N.value('Manzana[1]', 'VARCHAR(20)'),
				[E].[Lote] = T.N.value('Lote[1]', 'VARCHAR(20)'),
				[E].[Kilometro] = T.N.value('Kilometro[1]', 'VARCHAR(20)'),
				[E].[IdPais] = T.N.value('IdPais[1]', 'INT'),
				[E].[UsuarioModifico] = @UsuarioRegistro,
				[E].[FechaModificado] = @FechaRegistro
			FROM 
			[ERP].[Establecimiento] AS E
			INNER JOIN @XMLEstablecimiento.nodes('/Establecimiento') AS T(N) ON E.ID = T.N.value('ID[1]', 'INT'); 

			INSERT INTO [ERP].[Trabajador]
				([IdEntidad]
				,[IdEmpresa]
				,[NombreImagen]
				,[UsuarioRegistro]
				,[FechaRegistro]
				,[FlagBorrador]
				,[Flag])
			VALUES
				(@IdEntidad,
				@IdEmpresa,
				@NombreImagen,
				@UsuarioRegistro,
				@FechaRegistro,
				0,
				1)

			SET @ID = CAST(SCOPE_IDENTITY() AS INT);

			SELECT @ID;
		END
		ELSE
		BEGIN
			SELECT -1;
		END
	END

END
