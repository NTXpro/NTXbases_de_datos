CREATE PROCEDURE [ERP].[Usp_Upd_Comprobante]
@IdComprobante	 INT,
@Serie			 VARCHAR(4),
@IdTipoComprobante INT,
@IdEmpresa		 INT,
@XMLComprobante	 XML,
@DataResult VARCHAR(MAX) OUT,
@XMLVale		 XML
AS
BEGIN		
SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET @DataResult = '';
		DECLARE @SerieDocumentoComprobante VARCHAR(20) = NULL
		DECLARE @SerieDocumentoComprobanteSunat VARCHAR(20) = NULL
		DECLARE @Documento VARCHAR(20) = (SELECT Documento FROM ERP.Comprobante WHERE ID = @IdComprobante);
		DECLARE @FlagControlaStock BIT = (SELECT T.N.value('FlagControlarStock[1]','BIT') FROM @XMLComprobante.nodes('/ArchivoPlanoComprobante') AS T(N));
		DECLARE @FlagGenerarVale BIT = (SELECT T.N.value('FlagGenerarVale[1]','BIT') FROM @XMLComprobante.nodes('/ArchivoPlanoComprobante') AS T(N));
		DECLARE @IdComprobanteEstado INT = (SELECT IdComprobanteEstado FROM ERP.Comprobante WHERE ID = @IdComprobante)
		DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.Comprobante WHERE ID = @IdComprobante)
		DECLARE @IdVale INT = (SELECT IdVale FROM ERP.Comprobante WHERE ID = @IdComprobante);
		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
		DECLARE @DocumentoXML VARCHAR(20) = (SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLComprobante.nodes('/ArchivoPlanoComprobante') AS T(N));

		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLComprobante.nodes('/ArchivoPlanoComprobante') AS T(N)) = 0 ) 
			BEGIN
				------========= SE GENERAN EL CORRELATIVO DEL COMPROBANTE =========------
				IF (@DocumentoXML = '' OR
				@DocumentoXML IS NULL OR
				@DocumentoXML = '00000000')
				BEGIN
					SET @Documento = (SELECT [ERP].[GenerarDocumentoComprobante](@Serie,@IdComprobante,@IdEmpresa));
				END
				ELSE
				BEGIN
					SET @Documento = (SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLComprobante.nodes('/ArchivoPlanoComprobante') AS T(N));
				END

				SET @SerieDocumentoComprobante = @Serie + '-'+@Documento

				SET @SerieDocumentoComprobanteSunat = @SerieDocumentoComprobante
				----===============================================================-------

				------========= SE GENERAN LOS VALES DE SALIDA =========------

				IF @FlagControlaStock = 1 AND @FlagGenerarVale = 1 --VALE DE SALIDA
				BEGIN
					EXEC ERP.Usp_Validar_StockProducto @DataResult OUT, @XMLVale,0
				END
				----===============================================================-------
			END
		ELSE
		BEGIN
			IF @Documento = '' OR @Documento IS NULL OR @Documento = '00000000'
			BEGIN
				SET @Documento =  @DocumentoXML
			END
		END

		IF(LEN(@DataResult) = 0)
		BEGIN

			------========= SE MODIFICA COMPROBANTE CABECERA =========------

			UPDATE ERP.Comprobante 
			SET Documento		=	@Documento,
				Serie			=	T.N.value('Serie[1]',					'VARCHAR(4)'),
				SerieDocumentoComprobante = @SerieDocumentoComprobante,
				SerieDocumentoComprobanteSunat = @SerieDocumentoComprobanteSunat,
				IdCliente		=	CASE WHEN (T.N.value('IdCliente[1]',    'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdCliente[1]',			'INT')
									END,
				IdProyecto		=	CASE WHEN (T.N.value('IdProyecto[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdProyecto[1]',			'INT')
									END,
				IdEstablecimiento=	CASE WHEN (T.N.value('IdEstablecimiento[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdEstablecimiento[1]',			'INT')
									END,
				IdEstablecimientoCliente=	CASE WHEN (T.N.value('IdEstablecimientoCliente[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdEstablecimientoCliente[1]',			'INT')
									END,
				IdVendedor		= 	CASE WHEN (T.N.value('IdVendedor[1]',	'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdVendedor[1]',			'INT')
									END,
				IdMotivoNotaCredito =	CASE WHEN (T.N.value('IdMotivoNotaCredito[1]','INT') = 0) THEN
											NULL
										ELSE 
											T.N.value('IdMotivoNotaCredito[1]',			'INT')
										END,
				IdMotivoNotaDebito =	CASE WHEN (T.N.value('IdMotivoNotaDebito[1]','INT') = 0) THEN
											NULL
										ELSE 
											T.N.value('IdMotivoNotaDebito[1]',			'INT')
										END,
				IdAlmacen		=	T.N.value('IdAlmacen[1]',				'INT'),
				IdMoneda		=	T.N.value('IdMoneda[1]',				'INT'),
				IdDetraccion	=	CASE WHEN (T.N.value('IdDetraccion[1]',				'INT') = 0) THEN
											NULL
										ELSE 
											T.N.value('IdDetraccion[1]',				'INT')
										END,
				IdCuentaDetraccion	= CASE WHEN (T.N.value('IdCuentaDetraccion[1]',				'INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdCuentaDetraccion[1]',				'INT')
				END,
				IdListaPrecio	=	T.N.value('IdListaPrecio[1]',			'INT'),
				Fecha			=	T.N.value('Fecha[1]',					'DATETIME'),
				FechaVencimiento=	T.N.value('FechaVencimiento[1]',		'DATETIME'),
				DiasVencimiento	=	T.N.value('DiasVencimiento[1]',			'INT'),
				Observacion		=	T.N.value('Observacion[1]',				'VARCHAR(250)'),
				CondicionPago	=	T.N.value('CondicionPago[1]',		'VARCHAR(250)'),
				TipoCambio		=	T.N.value('TipoCambio[1]',				'DECIMAL(14,5)'),
				PorcentajeIGV	=	T.N.value('PorcentajeIGV[1]',			'DECIMAL(14,5)'),
				TotalDetalleISC = T.N.value('TotalDetalleISC[1]',	'DECIMAL(14,5)'),
				TotalDetalleAfecto = T.N.value('TotalDetalleAfecto[1]',	'DECIMAL(14,5)'),
				TotalDetalleInafecto = T.N.value('TotalDetalleInafecto[1]','DECIMAL(14,5)'),
				TotalDetalleExportacion = T.N.value('TotalDetalleExportacion[1]','DECIMAL(14,5)'),
				TotalDetalleGratuito = T.N.value('TotalDetalleGratuito[1]','DECIMAL(14,5)'),
				TotalDetalle	=	T.N.value('TotalDetalle[1]',			'DECIMAL(14,5)'),
				PorcentajeDescuento		=	T.N.value('PorcentajeDescuento[1]',		'DECIMAL(14,5)'),
				ImporteDescuento=	T.N.value('ImporteDescuento[1]',		'DECIMAL(14,5)'),
				SubTotal		=	T.N.value('SubTotal[1]',				'DECIMAL(14,5)'),
				IGV				=	T.N.value('IGV[1]',						'DECIMAL(14,5)'),
				Total			=	T.N.value('Total[1]',					'DECIMAL(14,5)'),
				PorcentajePercepcion =	T.N.value('PorcentajePercepcion[1]',		'DECIMAL(14,5)'), 
				ImportePercepcion =	T.N.value('ImportePercepcion[1]',		'DECIMAL(14,5)'), 
				TotalPercepcion	=	T.N.value('TotalPercepcion[1]',			'DECIMAL(14,5)'), 
				PorcentajeDetraccion =	T.N.value('PorcentajeDetraccion[1]',		'DECIMAL(14,5)'), 
				ImporteDetraccion =	T.N.value('ImporteDetraccion[1]',		'DECIMAL(14,5)'), 
				TotalDetraccion	=	T.N.value('TotalDetraccion[1]',			'DECIMAL(14,5)'), 
				FlagExportacion	=	T.N.value('FlagExportacion[1]',			'BIT'),
				FlagPercepcion	=	T.N.value('FlagPercepcion[1]',			'BIT'),
				FlagDetraccion	=	T.N.value('FlagDetraccion[1]',			'BIT'),
				FlagAnticipo	=	T.N.value('FlagAnticipo[1]',			'BIT'),
				FlagBorrador	=	T.N.value('FlagBorrador[1]',			'BIT'),
				FlagComprobanteElectronico	=	T.N.value('FlagComprobanteElectronico[1]',			'BIT'),
				NumeroPlaca =   T.N.value('NumeroPlaca[1]',			'VARCHAR(10)'),
				UsuarioModifico =   T.N.value('UsuarioModifico[1]',			'VARCHAR(250)'),
				FechaModificado =   @FechaActual,
				IdVale = @IdVale,
				FlagControlarStock = @FlagControlaStock,
				FlagGenerarVale = @FlagGenerarVale,
			    ImporteAdelanto= T.N.value('ImporteAdelanto[1]','DECIMAL(14,5)'),
				PorcentajeAdelanto=T.N.value('PorcentajeAdelanto[1]','DECIMAL(15,5)'),
				IdEfectivo	=	T.N.value('IdEfectivo[1]',			'INT')
			FROM @XMLComprobante.nodes('/ArchivoPlanoComprobante')	AS T(N)
			WHERE ID = @IdComprobante

			----===============================================================-------
			------========= SE INSERTA COMPROBANTE DETALLE =========------

			DELETE FROM [ERP].[ComprobanteDetalle] WHERE IdComprobante = @IdComprobante

			INSERT INTO [ERP].[ComprobanteDetalle]
			 (
				 IdComprobante
				,IdProducto
				,Nombre
				,NumeroLote
				,Fecha
				,Cantidad
				,PorcentajeDescuento
				,PorcentajeISC
				,PrecioPromedio
				,PrecioUnitarioLista
				,PrecioUnitarioListaSinIGV
				,PrecioUnitarioValorISC
				,PrecioUnitarioISC
				,PrecioUnitarioDescuento
				,PrecioUnitarioSubTotal
				,PrecioUnitarioIGV
				,PrecioUnitarioTotal
				,PrecioLista
				,FlagISC
				,FlagAfecto
				,FlagGratuito
				,PrecioDescuento
				,PrecioSubTotal
				,PrecioIGV
				,PrecioTotal
				,FechaRegistro
			 )
			SELECT
			@IdComprobante												AS IdComprobante,
			T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
			T.N.value('Nombre[1]'					,'VARCHAR(MAX)')	AS Nombre,
			T.N.value('NumeroLote[1]'					,'VARCHAR(20)')	AS NumeroLote,
			T.N.value('Fecha[1]'					,'DATETIME')		AS Fecha,
			T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad,
			T.N.value('PorcentajeDescuento[1]'		,'DECIMAL(14,5)')	AS PorcentajeDescuento,
			T.N.value('PorcentajeISC[1]'			,'DECIMAL(14,5)')	AS PorcentajeISC,
			T.N.value('PrecioPromedio[1]'			,'DECIMAL(14,5)')	AS PrecioPromedio,
			T.N.value('PrecioUnitarioLista[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioLista,
			T.N.value('PrecioUnitarioListaSinIGV[1]','DECIMAL(14,5)')	AS PrecioUnitarioListaSinIGV,
			T.N.value('PrecioUnitarioValorISC[1]'	,'DECIMAL(14,5)')	AS PrecioUnitarioValorISC,
			T.N.value('PrecioUnitarioISC[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioISC,
			T.N.value('PrecioUnitarioDescuento[1]'	,'DECIMAL(14,5)')	AS PrecioUnitarioDescuento,
			T.N.value('PrecioUnitarioSubTotal[1]'	,'DECIMAL(14,5)')	AS PrecioUnitarioSubTotal,
			T.N.value('PrecioUnitarioIGV[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioIGV,
			T.N.value('PrecioUnitarioTotal[1]'		,'DECIMAL(14,5)')	AS PrecioUnitarioTotal,
			T.N.value('PrecioLista[1]'				,'DECIMAL(14,5)')	AS PrecioLista,
			T.N.value('FlagISC[1]'					,'BIT')				AS FlagISC,
			T.N.value('FlagAfecto[1]'				,'BIT')				AS FlagAfecto,
			T.N.value('FlagGratuito[1]'				,'BIT')				AS FlagGratuito,
			T.N.value('PrecioDescuento[1]'			,'DECIMAL(14,5)')	AS PrecioDescuento,
			T.N.value('PrecioSubTotal[1]'			,'DECIMAL(14,5)')	AS PrecioSubTotal,
			T.N.value('PrecioIGV[1]'				,'DECIMAL(14,5)')	AS PrecioIGV,
			T.N.value('PrecioTotal[1]'				,'DECIMAL(14,5)')	AS PrecioTotal,
			@FechaActual									AS FechaRegistro
			FROM @XMLComprobante.nodes('/ListaArchivoPlanoComprobanteDetalle/ArchivoPlanoComprobanteDetalle') AS T(N)	

			----===============================================================-------

			------========= SE INSERTA COMPROBANTE REFERENCIA =========------

			IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLComprobante.nodes('/ArchivoPlanoComprobante') AS T(N)) = 0)
			BEGIN
				UPDATE R SET
						R.IdGuiaRemisionEstado = 2 --EMITIDO
				FROM ERP.GuiaRemision R
				INNER JOIN ERP.ComprobanteReferencia CR ON CR.IdReferencia = R.ID
				WHERE CR.IdReferenciaOrigen = 3 AND CR.IdComprobante = @IdComprobante 

				UPDATE P SET
					P.IdPedidoEstado = 2 --EMITIDO
				FROM ERP.Pedido P
				INNER JOIN ERP.ComprobanteReferencia CR ON CR.IdReferencia = P.ID
				WHERE CR.IdReferenciaOrigen = 9 AND CR.IdComprobante = @IdComprobante 
			END


			DELETE FROM [ERP].[ComprobanteReferencia] WHERE IdComprobante = @IdComprobante
			
			INSERT INTO [ERP].[ComprobanteReferencia]
				 (
					   IdComprobante
					  ,IdReferenciaOrigen
					  ,IdReferencia
					  ,IdTipoComprobante
					  ,Serie
					  ,Documento
					  ,Total
					  ,FlagInterno
				 )
				SELECT
				@IdComprobante										AS IdComprobante,
				CASE WHEN (T.N.value('IdReferenciaOrigen[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdReferenciaOrigen[1]',			'INT')
				END													AS IdReferenciaOrigen,
				T.N.value('IdReferencia[1]'	,'INT')					AS IdReferencia,
				T.N.value('IdTipoComprobante[1]'	,'INT')			AS IdTipoComprobante,
				T.N.value('Serie[1]'	,'VARCHAR(4)')				AS Serie,
				T.N.value('Documento[1]'	,'VARCHAR(20)')			AS Documento,
				T.N.value('Total[1]'	,'DECIMAL(14,5)')			AS Total,
				T.N.value('FlagInterno[1]'	,'BIT')				AS FlagInterno
				FROM @XMLComprobante.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia') AS T(N)

			IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLComprobante.nodes('/ArchivoPlanoComprobante') AS T(N)) = 0)
			BEGIN
				UPDATE R SET
						R.IdGuiaRemisionEstado = 4 --IMPORTADO
				FROM ERP.GuiaRemision R
				INNER JOIN ERP.ComprobanteReferencia CR ON CR.IdReferencia = R.ID
				WHERE CR.IdReferenciaOrigen = 3 AND CR.IdComprobante = @IdComprobante 

				UPDATE P SET
					P.IdPedidoEstado = T.N.value('IdEstado[1]','INT') --IMPORTADO
				FROM ERP.Pedido P
				INNER JOIN @XMLComprobante.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia') AS T(N) ON T.N.value('IdReferencia[1]','INT') = P.ID
				WHERE T.N.value('IdReferenciaOrigen[1]'	,'INT') = 9 
			END

			----===============================================================-------

			DECLARE @IdAsiento INT = (SELECT IdAsiento FROM ERP.Comprobante WHERE ID = @IdComprobante)

			IF @IdAsiento IS NOT NULL
			BEGIN
				EXEC [ERP].[Usp_Ins_AsientoContable_Venta_Reprocesar] @IdAsiento, @IdComprobante,4/*REGISTRO DE VENTAS(ORIGEN)*/,2/*VENTAS(SISTEMA)*/
			END

			EXEC [ERP].[Usp_Upd_CuentaCobrar_Comprobante] @IdComprobante

			SELECT @IdComprobante
		END
		ELSE
		BEGIN
			SELECT -1
		END
END