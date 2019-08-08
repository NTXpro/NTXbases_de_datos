
CREATE PROCEDURE [ERP].[Usp_Ins_Requerimiento]
@IdRequerimiento	 INT OUTPUT,
@XMLRequerimiento	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		DECLARE @Documento VARCHAR(20) = NULL;
		DECLARE @Fecha DATETIME = (SELECT T.N.value('Fecha[1]','DATETIME') FROM @XMLRequerimiento.nodes('/ArchivoPlanoRequerimiento') AS T(N));
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLRequerimiento.nodes('/ArchivoPlanoRequerimiento') AS T(N));
		DECLARE @Serie VARCHAR(4) = (SELECT T.N.value('Serie[1]','VARCHAR(4)') FROM @XMLRequerimiento.nodes('/ArchivoPlanoRequerimiento') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.Requerimiento WHERE ID = @IdRequerimiento)
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLRequerimiento.nodes('/ArchivoPlanoRequerimiento') AS T(N)) = 0 ) 
		BEGIN
			DECLARE @UltimoCorrelativoGenerado INT= (SELECT MAX(CAST(Documento AS INT)) FROM ERP.Requerimiento WHERE IdEmpresa = @IdEmpresa AND Serie = @Serie AND FlagBorrador = 0);
			IF @UltimoCorrelativoGenerado IS NULL 
				BEGIN
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(1)), 8)
				END
			ELSE
				BEGIN
					SET @UltimoCorrelativoGenerado = @UltimoCorrelativoGenerado + 1
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(@UltimoCorrelativoGenerado)), 8)
				END
		END

		INSERT INTO ERP.Requerimiento(
									   IdEmpresa
									  ,Fecha
									  ,IdTipoComprobante
									  ,Serie
									  ,Documento
									  ,IdEntidad
									  ,DiasVencimiento
									  ,FechaVencimiento
									  ,IdEstablecimiento
									  ,IdProyecto
									  ,IdRequerimientoEstado
									  ,Observacion
									  ,FechaRegistro
									  ,UsuarioRegistro
									  ,FechaModificado
									  ,UsuarioModifico
									  ,FlagBorrador
									  ,Flag
									) 
		SELECT
			T.N.value('IdEmpresa[1]',	'INT')						AS IdEmpresa,
			T.N.value('Fecha[1]',				'DATETIME')			AS Fecha,
			T.N.value('IdTipoComprobante[1]',	'INT')				AS IdTipoComprobante,
			T.N.value('Serie[1]',			'VARCHAR(4)')			AS Serie,
			@Documento												AS Documento,
			CASE WHEN (T.N.value('IdEntidad[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdEntidad[1]',			'INT')
			END														AS IdEntidad,
			T.N.value('DiasVencimiento[1]',			'INT')			AS DiasVencimiento,
			T.N.value('FechaVencimiento[1]',			'DATETIME')			AS DiasVencimiento,
			CASE WHEN (T.N.value('IdEstablecimiento[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdEstablecimiento[1]',			'INT')
			END														AS IdEstablecimiento,
			CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdProyecto[1]',			'INT')
			END														AS IdProyecto,
			T.N.value('IdRequerimientoEstado[1]',	'INT')			AS IdRequerimientoEstado,
			T.N.value('Observacion[1]',	'VARCHAR(MAX)')				AS Observacion,
			DATEADD(HOUR, 3, GETDATE())								AS FechaRegistro,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
			DATEADD(HOUR, 3, GETDATE())								AS FechaModificado,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioModifico,
			T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador,
			CAST(1 AS BIT)											AS Flag
		FROM @XMLRequerimiento.nodes('/ArchivoPlanoRequerimiento')	AS T(N)
		SET @IdRequerimiento = SCOPE_IDENTITY()


		INSERT INTO [ERP].[RequerimientoDetalle]
		 (
			 IdRequerimiento
			,IdProducto
			,Nombre
			,Cantidad			
		 )
		SELECT
		@IdRequerimiento											AS IdRequerimiento,
		T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
		T.N.value('Nombre[1]'					,'VARCHAR(max)')	AS Nombre,
		T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad
		FROM @XMLRequerimiento.nodes('/ListaArchivoPlanoRequerimientoDetalle/ArchivoPlanoRequerimientoDetalle') AS T(N)	



		INSERT INTO [ERP].[RequerimientoReferencia]
		 (
			  IdRequerimiento
			  ,IdReferenciaOrigen
			  ,IdReferencia
			  ,IdTipoComprobante
			  ,Serie
			  ,Documento
			  ,FlagInterno
		 )
		SELECT
		@IdRequerimiento									AS IdRequerimiento,
		CASE WHEN (T.N.value('IdReferenciaOrigen[1]','INT') = 0) THEN
			NULL
		ELSE 
			T.N.value('IdReferenciaOrigen[1]',			'INT')
		END														AS IdReferenciaOrigen,
		T.N.value('IdReferencia[1]'	,'INT')					AS IdReferencia,
		T.N.value('IdTipoComprobante[1]'	,'INT')			AS IdTipoComprobante,
		T.N.value('Serie[1]'	,'VARCHAR(4)')				AS Serie,
		T.N.value('Documento[1]'	,'VARCHAR(8)')			AS Documento,
		T.N.value('FlagInterno[1]'	,'BIT')				AS FlagInterno
		FROM @XMLRequerimiento.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia') AS T(N)
		
		SET NOCOUNT OFF;
END
