CREATE PROCEDURE [ERP].[Usp_Upd_Vale]
@IdVale	 INT,
@DataResult VARCHAR(MAX) OUT,
@XMLVale	 XML
AS
BEGIN		
SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET @DataResult = '';
		DECLARE @Documento VARCHAR(20) = NULL
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
						SET @UltimoCorrelativoGenerado = @UltimoCorrelativoGenerado + 1;
						SET @UltimoOrdenGenerado = ISNULL(@UltimoOrdenGenerado,0) + 1;
						SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(@UltimoCorrelativoGenerado)), 8);
					END
				----===============================================================-------
		END
		IF @FlagBorrador = 0
		BEGIN
			SET @Documento =  (SELECT Documento FROM ERP.Vale WHERE ID = @IdVale)
			SET @UltimoOrdenGenerado =  (SELECT Orden FROM ERP.Vale WHERE ID = @IdVale)
		END

		------========= SE VALIDA EL STOCK DE LOS VALES DE SALIDA =========------
		BEGIN 
		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N)) = 0 AND @IdTipoMovimiento = 2)
			BEGIN
				EXEC [ERP].[Usp_Validar_StockProducto] @DataResult OUT, @XMLVale, @IdVale
			END
		END 
		----===============================================================-------

		IF(LEN(@DataResult) = 0)
		BEGIN
			------========= SE MODIFICA VALE CABECERA =========------
			UPDATE ERP.Vale 
			SET Serie			=	T.N.value('Serie[1]',			'VARCHAR(4)'),
				Documento		=	@Documento,
				Orden			=	@UltimoOrdenGenerado,
				IdEntidad		=	CASE WHEN (T.N.value('IdEntidad[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdEntidad[1]',			'INT')
									END,
				IdAlmacen=	CASE WHEN (T.N.value('IdAlmacen[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdAlmacen[1]',			'INT')
									END,
				IdMoneda		= 	CASE WHEN (T.N.value('IdMoneda[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdMoneda[1]',			'INT')
									END,
				IdProyecto =	CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN
											NULL
										ELSE 
											T.N.value('IdProyecto[1]',			'INT')
										END,
				IdConcepto =	CASE WHEN (T.N.value('IdConcepto[1]','INT') = 0) THEN
											NULL
										ELSE 
											T.N.value('IdConcepto[1]',			'INT')
										END,
				Fecha			=	T.N.value('Fecha[1]',					'DATETIME'),
				Observacion		=	T.N.value('Observacion[1]',				'VARCHAR(250)'),
				TipoCambio		=	T.N.value('TipoCambio[1]',				'DECIMAL(14,5)'),
				PorcentajeIGV	=	T.N.value('PorcentajeIGV[1]',				'DECIMAL(14,5)'),
				SubTotal		=	T.N.value('SubTotal[1]',				'DECIMAL(14,5)'),
				IGV				=	T.N.value('IGV[1]',						'DECIMAL(14,5)'),
				Total			=	T.N.value('Total[1]',					'DECIMAL(14,5)'),
				Peso			=	T.N.value('Peso[1]',					'DECIMAL(14,5)'),
				UsuarioModifico =   T.N.value('UsuarioModifico[1]',			'VARCHAR(250)'),
				FechaModificado =   DATEADD(HOUR, 3, GETDATE()),
				FlagBorrador	=	T.N.value('FlagBorrador[1]',			'BIT'),
				FlagTransferencia = T.N.value('FlagTransferencia[1]',		'BIT'),
				FlagTransformacion = T.N.value('FlagTransformacion[1]',		'BIT')
			FROM @XMLVale.nodes('/ArchivoPlanoVale')	AS T(N)
			WHERE ID = @IdVale
			----===============================================================-------

			------========= SE INSERTA VALE DETALLE =========------

			DELETE FROM [ERP].[ValeDetalle] WHERE IdVale = @IdVale

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
						OC.IdOrdenCompraEstado = 3
				FROM ERP.OrdenCompra OC
				INNER JOIN ERP.ValeReferencia VR ON VR.IdReferencia = OC.ID
				WHERE VR.IdReferenciaOrigen = 7 AND VR.IdVale = @IdVale 
			END
			----===============================================================-------

			------========= SE INSERTA VALE REFERENCIA =========------

			DELETE FROM [ERP].[ValeReferencia] WHERE IdVale = @IdVale

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
END
