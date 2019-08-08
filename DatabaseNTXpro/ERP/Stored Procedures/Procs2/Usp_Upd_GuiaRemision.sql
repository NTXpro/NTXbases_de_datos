
CREATE PROC [ERP].[Usp_Upd_GuiaRemision]
@IdGuiaRemision INT,
@IdVale INT OUT,
@DataResult VARCHAR(MAX) OUT,
@Serie			 VARCHAR(4),
@IdEmpresa		 INT,
@XMLGuiaRemision	 XML,
@XMLVale XML

AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000

	DECLARE @FlagBorradorGuia BIT = CAST((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision') AS T(N)) AS BIT);
	DECLARE @IdValeGuia INT = (SELECT T.N.value('IdVale[1]','INT') FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision') AS T(N));
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

	DECLARE @TipoMovimientoVale INT =  (SELECT T.N.value('IdTipoMovimiento[1]','INT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N));

	DECLARE @FlagValidarStock BIT = (SELECT T.N.value('FlagValidarStock[1]','BIT') FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision') AS T(N));

	DECLARE @SerieDocumentoComprobante VARCHAR(20) = NULL
	DECLARE @Documento VARCHAR(20) = NULL
	DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision)

	IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision') AS T(N)) = 0 ) 
			BEGIN
				IF ((SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision') AS T(N)) = '' OR
				(SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision') AS T(N)) IS NULL OR
				(SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision') AS T(N)) = '00000000')
				BEGIN
					SET @Documento = (SELECT [ERP].[GenerarDocumentoGuiaRemision](@Serie,@IdGuiaRemision,@IdEmpresa));
				END
				ELSE
				BEGIN
					SET @Documento = (SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision') AS T(N));
				END

				SET @SerieDocumentoComprobante = @Serie + '-'+@Documento
				------========= VALIDAR STOCK =========------

				IF(@FlagValidarStock = 1)
				BEGIN
					IF(@TipoMovimientoVale = 2)
					BEGIN
						SET @IdVale = ISNULL((SELECT IdVale FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision),0);
						EXEC ERP.Usp_Validar_StockProducto @DataResult OUT, @XMLVale,@IdVale
					END
					
				END
				----===============================================================-------
			END

			IF(LEN(@DataResult) = 0)
			BEGIN
				UPDATE ERP.GuiaRemision 
						SET 
										IdEmpresa = T.N.value('IdEmpresa[1]',					'INT'),
										IdEntidad = CASE WHEN T.N.value('IdEntidad[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdEntidad[1]','INT') END,
										IdVendedor = CASE WHEN T.N.value('IdVendedor[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdVendedor[1]','INT') END,
										IdMoneda = T.N.value('IdMoneda[1]',					'INT'),
										IdEstablecimiento = CASE WHEN T.N.value('IdEstablecimiento[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdEstablecimiento[1]','INT') END,
										EstablecimientoOrigen = T.N.value('EstablecimientoOrigen[1]',			'VARCHAR(250)')	,
										EstablecimientoDestino = T.N.value('EstablecimientoDestino[1]',			'VARCHAR(250)')	,
										IdChofer = CASE WHEN T.N.value('IdChofer[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdChofer[1]','INT') END,
										IdTransporte = CASE WHEN T.N.value('IdTransporte[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdTransporte[1]','INT') END,
										IdVehiculo = CASE WHEN T.N.value('IdVehiculo[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdVehiculo[1]','INT') END,
										IdAlmacen = CASE WHEN T.N.value('IdAlmacen[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdAlmacen[1]','INT') END,
										IdMotivoTraslado = CASE WHEN T.N.value('IdMotivoTraslado[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdMotivoTraslado[1]','INT') END,
										IdModalidadTraslado = CASE WHEN T.N.value('IdModalidadTraslado[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdModalidadTraslado[1]','INT') END,
										IdUnidadMedida = CASE WHEN T.N.value('IdUnidadMedida[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdUnidadMedida[1]','INT') END,
										IdUbigeoOrigen = CASE WHEN T.N.value('IdUbigeoOrigen[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdUbigeoOrigen[1]','INT') END,
										IdUbigeoDestino = CASE WHEN T.N.value('IdUbigeoDestino[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdUbigeoDestino[1]','INT') END,
										IdTipoMovimiento = CASE WHEN T.N.value('IdTipoMovimiento[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdTipoMovimiento[1]','INT') END , 
										UsuarioModifico = T.N.value('UsuarioModifico[1]',					'VARCHAR(250)'),
										FechaModificado = @FechaActual,
										TipoCambio = T.N.value('TipoCambio[1]',					'DECIMAL(14,5)'),
										Fecha = T.N.value('Fecha[1]',					'DATETIME'),
										Serie = T.N.value('Serie[1]',					'VARCHAR(10)'),
										Documento = @Documento,
										NumeroContenedor = T.N.value('NumeroContenedor[1]',					'VARCHAR(250)'),
										CodigoPuerto = T.N.value('CodigoPuerto[1]',					'VARCHAR(250)'),
										Observacion = T.N.value('Observacion[1]',					'VARCHAR(250)'),
										PorcentajeIGV = T.N.value('PorcentajeIGV[1]',					'DECIMAL(14,5)'),
										SubTotal = T.N.value('SubTotal[1]',					'DECIMAL(14,5)'),
										IGV = T.N.value('IGV[1]',					'DECIMAL(14,5)'),
										Total = T.N.value('Total[1]',					'DECIMAL(14,5)'),
										TotalPeso = T.N.value('TotalPeso[1]',					'DECIMAL(14,5)'),
										Flag = T.N.value('Flag[1]',					'BIT'),
										FlagBorrador = T.N.value('FlagBorrador[1]',					'BIT'),
										FlagValidarStock = T.N.value('FlagValidarStock[1]',					'BIT'),
										FlagGuiaElectronico = T.N.value('FlagGuiaElectronico[1]',					'BIT'),
										IdListaPrecio = CASE WHEN T.N.value('IdListaPrecio[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdListaPrecio[1]','INT') END
				FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision')	AS T(N)
				WHERE ID = @IdGuiaRemision

				DELETE ERP.GuiaRemisionDetalle WHERE IdGuiaRemision = @IdGuiaRemision

				INSERT INTO ERP.GuiaRemisionDetalle(
										IdGuiaRemision,
										IdProducto,
										Nombre,
										Cantidad,
										Lote,
										Peso,
										PorcentajeISC,
										PrecioUnitarioLista,
										PrecioUnitarioListaSinIGV,
										PrecioUnitarioValorISC,
										PrecioUnitarioISC,
										PrecioUnitarioSubTotal,
										PrecioUnitarioIGV,
										PrecioUnitarioTotal,
										PrecioLista,
										PrecioSubTotal,
										PrecioIGV,
										PrecioTotal,
										PesoUnitario,
										FlagAfecto
										)	
								SELECT 
										@IdGuiaRemision												AS IdGuiaRemision,
										T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
										T.N.value('Nombre[1]'					,'VARCHAR(MAX)')	AS Nombre,
										T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad,
										T.N.value('Lote[1]'						,'VARCHAR(250)')    AS Lote,
										T.N.value('Peso[1]'					,'DECIMAL(14,5)')		AS Peso,
										T.N.value('PorcentajeISC[1]'			,'DECIMAL(14,5)')	AS PorcentajeISC,
										T.N.value('PrecioUnitarioLista[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioLista,
										T.N.value('PrecioUnitarioListaSinIGV[1]','DECIMAL(14,5)')	AS PrecioUnitarioListaSinIGV,
										T.N.value('PrecioUnitarioValorISC[1]'	,'DECIMAL(14,5)')	AS PrecioUnitarioValorISC,
										T.N.value('PrecioUnitarioISC[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioISC,
										T.N.value('PrecioUnitarioSubTotal[1]'	,'DECIMAL(14,5)')	AS PrecioUnitarioSubTotal,
										T.N.value('PrecioUnitarioIGV[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioIGV,
										T.N.value('PrecioUnitarioTotal[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioTotal,
										T.N.value('PrecioLista[1]'				,'DECIMAL(14,5)')	AS PrecioLista,
										T.N.value('PrecioSubTotal[1]'			,'DECIMAL(14,5)')	AS PrecioSubTotal,
										T.N.value('PrecioIGV[1]'				,'DECIMAL(14,5)')	AS PrecioIGV,
										T.N.value('PrecioTotal[1]'				,'DECIMAL(14,5)')	AS PrecioTotal,
										T.N.value('PesoUnitario[1]'				,'DECIMAL(14,5)')	AS PesoUnitario,
										T.N.value('FlagAfecto[1]'					,'BIT')				AS FlagAfecto
										FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision/ListaArchivoPlanoGuiaRemisionDetalle/ArchivoPlanoGuiaRemisionDetalle') AS T(N)	

				 ------=================================================================================------
			------=================== INSERTAR LA REFERENCIA DE LA GUIA REMISION ===================------
						
				IF(@FlagBorradorGuia = 0)
					BEGIN
						UPDATE P SET
							P.IdPedidoEstado = 2 --EMITIDO
						FROM ERP.Pedido P
						INNER JOIN ERP.GuiaRemisionReferencia CR ON CR.IdReferencia = P.ID
						WHERE CR.IdReferenciaOrigen = 9 AND CR.IdGuiaRemision = @IdGuiaRemision 
					END

				DELETE ERP.GuiaRemisionReferencia WHERE IdGuiaRemision = @IdGuiaRemision

				INSERT INTO ERP.GuiaRemisionReferencia(
										IdGuiaRemision,
										IdReferenciaOrigen,
										IdReferencia,
										IdTipoComprobante,
										Serie,
										Documento,
										FlagInterno
									)
									SELECT 
											@IdGuiaRemision,
											CASE WHEN (T.N.value('IdReferenciaOrigen[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferenciaOrigen[1]'	,'INT')	END AS IdReferenciaOrigen,
											CASE WHEN (T.N.value('IdReferencia[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferencia[1]'	,'INT')	END AS IdReferencia,
											T.N.value('IdTipoComprobante[1]'	,'INT')				AS IdTipoComprobante,
											T.N.value('Serie[1]'	,'VARCHAR(20)')					AS Serie,
											T.N.value('Documento[1]'	,'VARCHAR(20)')				AS Documento,
											T.N.value('FlagInterno[1]'	,'BIT')					AS FlagInterno
											FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision/ListaArchivoPlanoGuiaRemisionReferencia/ArchivoPlanoComprobanteReferencia')  AS T(N)
				
				IF(@FlagBorradorGuia = 0)
				BEGIN
					UPDATE P SET
						P.IdPedidoEstado = T.N.value('IdEstado[1]','INT') --IMPORTADO
					FROM ERP.Pedido P
					INNER JOIN @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision/ListaArchivoPlanoGuiaRemisionReferencia/ArchivoPlanoComprobanteReferencia') AS T(N) ON T.N.value('IdReferencia[1]','INT') = P.ID
					WHERE T.N.value('IdReferenciaOrigen[1]'	,'INT') = 9 
				END

				IF (@FlagBorradorGuia = 0)
				BEGIN
						SET @IdVale = ISNULL((SELECT IdVale FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision),0);
						SET @FlagValidarStock = (SELECT FlagValidarStock FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision);

						IF (@FlagValidarStock = 1) 
						BEGIN
							IF @IdVale != 0
							BEGIN
								EXEC [ERP].[Usp_Upd_Vale] @IdVale,@DataResult OUT, @XMLVale
							END
						END
				END

				SELECT @IdGuiaRemision
			END
			ELSE
			BEGIN
				SELECT -1
			END
END