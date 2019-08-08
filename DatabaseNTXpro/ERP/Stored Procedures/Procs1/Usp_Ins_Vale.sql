CREATE PROCEDURE [ERP].[Usp_Ins_Vale]
@IdVale	 INT OUT,
@DataResult VARCHAR(MAX) OUT,
@XMLVale	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		SET @DataResult = '';
		DECLARE @Documento VARCHAR(20) = NULL;
		DECLARE @Fecha DATETIME = (SELECT T.N.value('Fecha[1]','DATETIME') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N));
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N));
		DECLARE @IdTipoMovimiento INT = (SELECT T.N.value('IdTipoMovimiento[1]','INT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N));
		DECLARE @Serie VARCHAR(4) = (SELECT T.N.value('Serie[1]','VARCHAR(4)') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.Vale WHERE ID = @IdVale)
		
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N)) = 0 ) 
		BEGIN
			------========= SE GENERAN EL CORRELATIVO DEL VALE =========------
			DECLARE @UltimoCorrelativoGenerado INT= (SELECT MAX(CAST(Documento AS INT)) FROM ERP.Vale WHERE IdEmpresa = @IdEmpresa AND IdTipoMovimiento = @IdTipoMovimiento AND Serie = @Serie AND FlagBorrador = 0);
			DECLARE @UltimoOrdenGenerado INT= (SELECT MAX(Orden) FROM ERP.Vale WHERE IdEmpresa = @IdEmpresa AND FlagBorrador = 0);
			IF @UltimoCorrelativoGenerado IS NULL 
				BEGIN
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(1)), 8);
					SET @UltimoOrdenGenerado = 1;
				END
			ELSE
				BEGIN
					SET @UltimoCorrelativoGenerado = @UltimoCorrelativoGenerado + 1
					SET @UltimoOrdenGenerado = @UltimoOrdenGenerado + 1;
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(@UltimoCorrelativoGenerado)), 8)
				END
			----===============================================================-------
		END

		------========= SE VALIDA EL STOCK DE LOS VALES DE SALIDA =========------
		BEGIN 
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N)) = 0 AND @IdTipoMovimiento = 2)
			BEGIN
				EXEC [ERP].[Usp_Validar_StockProducto] @DataResult OUT, @XMLVale, 0
			END
		END 
		----===============================================================-------

		IF(LEN(@DataResult) = 0)
		BEGIN
			------========= SE INSERTA VALE CABECERA =========------
			INSERT INTO ERP.Vale(
										 IdEmpresa
										,IdTipoMovimiento
										,IdEntidad
										,IdAlmacen
										,IdMoneda
										,IdProyecto
										,IdConcepto
										,Fecha
										,IdValeEstado
										,Orden
										,IdTipoComprobante
										,Serie
										,Documento
										,Observacion
										,TipoCambio
										,PorcentajeIGV
										,SubTotal
										,IGV
										,Total
										,Peso
										,UsuarioRegistro
										,FechaRegistro
										,FlagBorrador
										,Flag
										,FlagTransferencia
										,FlagTransformacion
										,FlagComprobante
										,FlagGuiaRemision
										,FlagImportacion
										) 
			SELECT
				T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
				T.N.value('IdTipoMovimiento[1]',	'INT')				AS IdTipoMovimiento,
				CASE WHEN (T.N.value('IdEntidad[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdEntidad[1]',			'INT')
				END														AS IdEntidad,									
				CASE WHEN (T.N.value('IdAlmacen[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdAlmacen[1]',			'INT')
				END														AS IdAlmacen,
				CASE WHEN (T.N.value('IdMoneda[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdMoneda[1]',			'INT')
				END														AS IdMoneda,
				CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdProyecto[1]',			'INT')
				END														AS IdProyecto,
				CASE WHEN (T.N.value('IdConcepto[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdConcepto[1]',			'INT')
				END														AS IdConcepto,
				T.N.value('Fecha[1]',				'DATETIME')			AS Fecha,
				T.N.value('IdValeEstado[1]',		'INT')				AS IdValeEstado,
				@UltimoOrdenGenerado									AS Orden,
				T.N.value('IdTipoComprobante[1]',	'INT')				AS IdTipoComprobante,
				T.N.value('Serie[1]',			'VARCHAR(4)')		AS Serie,
				@Documento												AS Documento,
				T.N.value('Observacion[1]',			'VARCHAR(250)')		AS Observacion,
				T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,
				T.N.value('PorcentajeIGV[1]',			'DECIMAL(14,5)')AS PorcentajeIGV,
				T.N.value('SubTotal[1]',			'DECIMAL(14,5)')	AS SubTotal,
				T.N.value('IGV[1]',					'DECIMAL(14,5)')	AS IGV,
				T.N.value('Total[1]',				'DECIMAL(14,5)')	AS Total,
				T.N.value('Peso[1]',				'DECIMAL(14,5)')	AS Peso,
				T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
				DATEADD(HOUR, 3, GETDATE())								AS FechaRegistro,
				T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador,
				CAST(1 AS BIT)											AS Flag,
				T.N.value('FlagTransferencia[1]',		'BIT')			AS FlagTransferencia,
				T.N.value('FlagTransformacion[1]',		'BIT')			AS FlagTransformacion,
				T.N.value('FlagComprobante[1]',		'BIT')				AS FlagComprobante,
				T.N.value('FlagGuiaRemision[1]',		'BIT')			AS FlagGuiaRemision,
				T.N.value('FlagImportacion[1]',		'BIT')			AS FlagImportacion
			FROM @XMLVale.nodes('/ArchivoPlanoVale')	AS T(N)
		
			SET @IdVale = SCOPE_IDENTITY()

			----===============================================================-------

			------========= SE INSERTA VALE DETALLE =========------

			DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(T.N.value('IdProducto[1]','INT'))
									FROM @XMLVale.nodes('/ListaArchivoPlanoValeDetalle/ArchivoPlanoValeDetalle') AS T(N))
		
			DECLARE @i INT = 1;
			WHILE @i <= @TOTAL_ITEMS
			BEGIN
				INSERT INTO [ERP].[ValeDetalle]
				 (
					 IdVale
					,Item
					,IdProducto
					,Nombre
					,FlagAfecto
					,Cantidad			
					,PrecioUnitario
					,SubTotal
					,IGV
					,Total
					,Fecha
					,NumeroLote
				 )
				SELECT
				@IdVale														AS IdVale,
				T.N.value('Item[1]','INT'),
				T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
				T.N.value('Nombre[1]'					,'VARCHAR(255)')	AS Nombre,
				T.N.value('FlagAfecto[1]'				,'BIT')				AS FlagAfecto,
				T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad,
				T.N.value('PrecioUnitario[1]'			,'DECIMAL(14,5)')	AS PrecioUnitario,
				T.N.value('SubTotal[1]'			,'DECIMAL(14,5)')			AS SubTotal,
				T.N.value('IGV[1]'				,'DECIMAL(14,5)')			AS IGV,
				T.N.value('Total[1]'				,'DECIMAL(14,5)')		AS Total,
				T.N.value('Fecha[1]'				,'DATETIME')			AS Fecha,
				CASE WHEN (T.N.value('NumeroLote[1]','VARCHAR(20)') = '' OR T.N.value('NumeroLote[1]','VARCHAR(20)') IS NULL) AND (SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N)) = 0 THEN
					(SELECT [ERP].[GenerarNumeroLoteValeDetalle](@IdEmpresa,T.N.value('IdProducto[1]','INT'),T.N.value('Fecha[1]','DATETIME')))
				ELSE
					T.N.value('NumeroLote[1]','VARCHAR(20)')
				END AS NumeroLote
				FROM @XMLVale.nodes('/ListaArchivoPlanoValeDetalle/ArchivoPlanoValeDetalle') AS T(N)
				WHERE T.N.value('Item[1]','INT') = @i
			
				SET @i = @i + 1
			END
			----===============================================================-------

			------========= SE ACTUALIZA LOS ESTADOS DE LOS COMPROBANTES INTERNOS IMPORTADOS =========------
			IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N)) = 0)
			BEGIN
				UPDATE OC SET
						OC.IdOrdenCompraEstado = 1
				FROM ERP.OrdenCompra OC
				INNER JOIN ERP.ValeReferencia VR ON VR.IdReferencia = OC.ID
				WHERE VR.IdReferenciaOrigen = 7 AND VR.IdVale = @IdVale 
			END
			----===============================================================-------

			------========= SE INSERTA VALE REFERENCIA =========------
			INSERT INTO ERP.ValeReferencia(
											  IdVale,
											  IdReferenciaOrigen,
											  IdReferencia,
											  IdTipoComprobante,
											  Serie,
											  Documento,
											  FlagInterno
											)
			SELECT 
					@IdVale,
					T.N.value('IdReferenciaOrigen[1]'	,'INT')				AS IdCompraReferencia,
					CASE WHEN (T.N.value('IdReferencia[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferencia[1]'	,'INT')	END AS IdReferencia,
					T.N.value('IdTipoComprobante[1]'	,'INT')				AS IdTipoComprobante,
					T.N.value('Serie[1]'	,'VARCHAR(20)')					AS Serie,
					T.N.value('Documento[1]'	,'VARCHAR(20)')				AS Documento,
					T.N.value('FlagInterno[1]'	,'BIT')					AS FlagInterno
					FROM @XMLVale.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia')  AS T(N)
			----===============================================================-------

			------========= SE ACTUALIZA LOS ESTADOS DE LOS COMPROBANTES INTERNOS IMPORTADOS =========------

			IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N)) = 0)
			BEGIN
				UPDATE OC SET
						OC.IdOrdenCompraEstado = T.N.value('IdEstado[1]','INT') --IMPORTADO
				FROM ERP.OrdenCompra OC
				INNER JOIN @XMLVale.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia') AS T(N) ON T.N.value('IdReferencia[1]','INT') = OC.ID
				WHERE T.N.value('IdReferenciaOrigen[1]'	,'INT') = 7 
			END
			----===============================================================-------
		END
		ELSE
		BEGIN
			SET @IdVale = -1;
		END
		SET NOCOUNT OFF;
END