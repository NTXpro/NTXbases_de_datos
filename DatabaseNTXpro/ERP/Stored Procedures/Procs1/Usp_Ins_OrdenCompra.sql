CREATE PROCEDURE [ERP].[Usp_Ins_OrdenCompra]
@IdOrdenCompra	 INT OUTPUT,
@XMLOrdenCompra	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		DECLARE @Documento VARCHAR(20) = NULL;
		DECLARE @Fecha DATETIME = (SELECT T.N.value('Fecha[1]','DATETIME') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N));
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N));
		DECLARE @Serie VARCHAR(4) = (SELECT T.N.value('Serie[1]','VARCHAR(4)') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.OrdenCompra WHERE ID = @IdOrdenCompra)
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N)) = 0) 
		BEGIN
			DECLARE @UltimoCorrelativoGenerado INT= (SELECT MAX(CAST(Documento AS INT)) FROM ERP.OrdenCompra WHERE IdEmpresa = @IdEmpresa AND Serie = @Serie AND FlagBorrador = 0);
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

		INSERT INTO ERP.OrdenCompra(
									   IdEmpresa
									  ,IdMoneda
									  ,IdProveedor
									  ,IdProyecto
									  ,IdEstablecimiento
									  ,IdAlmacen
									  ,IdOrdenCompraEstado
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
									  ,FlagComparador
									  ,CondicionPago
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
			CASE WHEN (T.N.value('IdEstablecimiento[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdEstablecimiento[1]',			'INT')
			END														AS IdEstablecimiento,
			CASE WHEN (T.N.value('IdAlmacen[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdAlmacen[1]',			'INT')
			END														AS IdAlmacen,
			T.N.value('IdOrdenCompraEstado[1]',	'INT')				AS IdOrdenCompraEstado,
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
			T.N.value('FlagComparador[1]',		'BIT')				AS FlagComparador,
			T.N.value('FlagComparador[1]',		'BIT')				AS FlagComparador
			
		FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra')	AS T(N)
		SET @IdOrdenCompra = SCOPE_IDENTITY()


		INSERT INTO [ERP].[OrdenCompraDetalle]
		 (
		   IdOrdenCompra
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
		@IdOrdenCompra												AS IdOrdenCompra,
		T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
		T.N.value('Nombre[1]'					,'VARCHAR(255)')	AS Nombre,
		T.N.value('FlagAfecto[1]'				,'BIT')				AS FlagAfecto,
		T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad,
		T.N.value('PrecioUnitario[1]'			,'DECIMAL(14,5)')	AS PrecioUnitario,
		T.N.value('SubTotal[1]'			,'DECIMAL(14,5)')			AS SubTotal,
		T.N.value('IGV[1]'				,'DECIMAL(14,5)')			AS IGV,
		T.N.value('Total[1]'				,'DECIMAL(14,5)')		AS Total
		FROM @XMLOrdenCompra.nodes('/ListaArchivoPlanoOrdenCompraDetalle/ArchivoPlanoOrdenCompraDetalle') AS T(N)	

		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N)) = 0)
		BEGIN
			UPDATE R SET
					R.IdRequerimientoEstado = 1
			FROM ERP.Requerimiento R
			INNER JOIN ERP.OrdenCompraReferencia CR ON CR.IdReferencia = R.ID
			WHERE CR.IdReferenciaOrigen = 6 AND CR.IdOrdenCompra = @IdOrdenCompra 
		END



		INSERT INTO ERP.OrdenCompraReferencia(
										  IdOrdenCompra,
										  IdReferenciaOrigen,
										  IdReferencia,
										  IdTipoComprobante,
										  Serie,
										  Documento,
										  FlagInterno
										)
		SELECT 
				@IdOrdenCompra,
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
				FROM @XMLOrdenCompra.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia')  AS T(N)
		
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLOrdenCompra.nodes('/ArchivoPlanoOrdenCompra') AS T(N)) = 0)
		BEGIN
			UPDATE R SET
					R.IdRequerimientoEstado = 5 --IMPORTADO
			FROM ERP.Requerimiento R
			INNER JOIN ERP.OrdenCompraReferencia CR ON CR.IdReferencia = R.ID
			WHERE CR.IdReferenciaOrigen = 6 AND CR.IdOrdenCompra = @IdOrdenCompra 
		END


		SET NOCOUNT OFF;
END