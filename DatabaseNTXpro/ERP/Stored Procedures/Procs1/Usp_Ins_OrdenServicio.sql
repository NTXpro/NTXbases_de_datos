
CREATE PROCEDURE [ERP].[Usp_Ins_OrdenServicio]
@IdOrdenServicio	 INT OUTPUT,
@XMLOrdenServicio	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		DECLARE @Documento VARCHAR(20) = NULL;
		DECLARE @Fecha DATETIME = (SELECT T.N.value('Fecha[1]','DATETIME') FROM @XMLOrdenServicio.nodes('/ArchivoPlanoOrdenServicio') AS T(N));
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLOrdenServicio.nodes('/ArchivoPlanoOrdenServicio') AS T(N));
		DECLARE @Serie VARCHAR(4) = (SELECT T.N.value('Serie[1]','VARCHAR(4)') FROM @XMLOrdenServicio.nodes('/ArchivoPlanoOrdenServicio') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.OrdenServicio WHERE ID = @IdOrdenServicio)
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLOrdenServicio.nodes('/ArchivoPlanoOrdenServicio') AS T(N)) = 0) 
		BEGIN
			DECLARE @UltimoCorrelativoGenerado INT= (SELECT MAX(CAST(Documento AS INT)) FROM ERP.OrdenServicio WHERE IdEmpresa = @IdEmpresa AND Serie = @Serie AND FlagBorrador = 0);
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

		INSERT INTO ERP.OrdenServicio(
									   IdEmpresa
									  ,IdMoneda
									  ,IdProveedor
									  ,IdProyecto
									  ,IdOrdenServicioEstado
									  ,Fecha
									  ,TipoCambio
									  ,IdTipoComprobante
									  ,Serie
									  ,Documento
									  ,DiasVencimiento
									  ,FechaVencimiento
									  ,SubTotal
									  ,IGV
									  ,Total
									  ,PorcentajeIGV
									  ,Observacion
									  ,UsuarioRegistro
									  ,FechaRegistro
									  ,Flag
									  ,FlagBorrador
									  ,Contacto
									  ,FormaPago
									  ,TiempoServicio
									  ,Direccion
									) 
		SELECT
			T.N.value('IdEmpresa[1]',	'INT')						AS IdEmpresa,
			T.N.value('IdMoneda[1]',	'INT')						AS IdMoneda,
			CASE WHEN (T.N.value('IdProveedor[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdProveedor[1]',			'INT')
			END														AS IdProveedor,
			CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdProyecto[1]',			'INT')
			END														AS IdProyecto,
			T.N.value('IdOrdenServicioEstado[1]',	'INT')				AS IdOrdenServicioEstado,
			T.N.value('Fecha[1]',				'DATETIME')			AS Fecha,
			T.N.value('TipoCambio[1]',	'DECIMAL(14,5)')			AS TipoCambio,
			T.N.value('IdTipoComprobante[1]','INT')			AS IdTipoComprobante,
			T.N.value('Serie[1]',			'VARCHAR(4)')			AS Serie,
			@Documento												AS Documento,
			T.N.value('DiasVencimiento[1]',			'INT')			AS DiasVencimiento,
			T.N.value('FechaVencimiento[1]',		'DATETIME')		AS FechaVencimiento,
			T.N.value('SubTotal[1]',	'DECIMAL(14,5)')			AS SubTotal,
			T.N.value('IGV[1]',	'DECIMAL(14,5)')					AS IGV,
			T.N.value('Total[1]',	'DECIMAL(14,5)')				AS Total,
			T.N.value('PorcentajeIGV[1]',	'DECIMAL(14,5)')		AS PorcentajeIGV,
			T.N.value('Observacion[1]',	'VARCHAR(MAX)')				AS Observacion,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
			DATEADD(HOUR, 3, GETDATE())								AS FechaRegistro,
			CAST(1 AS BIT)											AS Flag,
			T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador,
			T.N.value('Contacto[1]', 'VARCHAR(255)')				AS Contacto,
			T.N.value('FormaPago[1]', 'VARCHAR(255)')				AS FormaPago,
			T.N.value('TiempoServicio[1]', 'VARCHAR(255)')			AS TiempoServicio,
			T.N.value('Direccion[1]', 'VARCHAR(255)')				AS Direccion
		FROM @XMLOrdenServicio.nodes('/ArchivoPlanoOrdenServicio')	AS T(N)
		SET @IdOrdenServicio = SCOPE_IDENTITY()


		INSERT INTO [ERP].[OrdenServicioDetalle]
		 (
		   IdOrdenServicio
		  ,IdProducto
		  ,Nombre
		  ,FlagAfecto
		  ,Cantidad
		  ,PrecioUnitario
		  ,SubTotal
		  ,IGV
		  ,Total	
		 )
		SELECT
		@IdOrdenServicio												AS IdOrdenServicio,
		T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
		T.N.value('Nombre[1]'					,'VARCHAR(255)')	AS Nombre,
		T.N.value('FlagAfecto[1]'				,'BIT')				AS FlagAfecto,
		T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad,
		T.N.value('PrecioUnitario[1]'			,'DECIMAL(14,5)')	AS PrecioUnitario,
		T.N.value('SubTotal[1]'			,'DECIMAL(14,5)')			AS SubTotal,
		T.N.value('IGV[1]'				,'DECIMAL(14,5)')			AS IGV,
		T.N.value('Total[1]'				,'DECIMAL(14,5)')		AS Total
		FROM @XMLOrdenServicio.nodes('/ListaArchivoPlanoOrdenServicioDetalle/ArchivoPlanoOrdenServicioDetalle') AS T(N)	

		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLOrdenServicio.nodes('/ArchivoPlanoOrdenServicio') AS T(N)) = 0)
		BEGIN
			UPDATE R SET
					R.IdRequerimientoEstado = 1
			FROM ERP.Requerimiento R
			INNER JOIN ERP.OrdenServicioReferencia CR ON CR.IdReferencia = R.ID
			WHERE CR.IdReferenciaOrigen = 6 AND CR.IdOrdenServicio = @IdOrdenServicio 
		END



		INSERT INTO ERP.OrdenServicioReferencia(
										  IdOrdenServicio,
										  IdReferenciaOrigen,
										  IdReferencia,
										  IdTipoComprobante,
										  Serie,
										  Documento,
										  FlagInterno
										)
		SELECT 
				@IdOrdenServicio,
				CASE WHEN (T.N.value('IdReferenciaOrigen[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdReferenciaOrigen[1]',			'INT')
				END														AS IdReferenciaOrigen,
				CASE WHEN (T.N.value('IdReferencia[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferencia[1]'	,'INT')	END AS IdReferencia,
				T.N.value('IdTipoComprobante[1]'	,'INT')				AS IdTipoComprobante,
				T.N.value('Serie[1]'	,'VARCHAR(20)')					AS Serie,
				T.N.value('Documento[1]'	,'VARCHAR(20)')				AS Documento,
				T.N.value('FlagInterno[1]'	,'BIT')					AS FlagInterno
				FROM @XMLOrdenServicio.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia')  AS T(N)
		
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLOrdenServicio.nodes('/ArchivoPlanoOrdenServicio') AS T(N)) = 0)
		BEGIN
			UPDATE R SET
					R.IdRequerimientoEstado = 5 --IMPORTADO
			FROM ERP.Requerimiento R
			INNER JOIN ERP.OrdenServicioReferencia CR ON CR.IdReferencia = R.ID
			WHERE CR.IdReferenciaOrigen = 6 AND CR.IdOrdenServicio = @IdOrdenServicio 
		END


		SET NOCOUNT OFF;
END
