CREATE PROCEDURE [ERP].[Usp_Upd_Pedido]
@IdPedido	 INT,
@Serie			 VARCHAR(4),
@IdEmpresa		 INT,
@XMLPedido	 XML
AS
BEGIN		
SET QUERY_GOVERNOR_COST_LIMIT 36000
		DECLARE @SerieDocumentoComprobante VARCHAR(20) = NULL
		DECLARE @SerieDocumentoComprobanteSunat VARCHAR(20) = NULL
		DECLARE @Documento VARCHAR(20) = NULL
		DECLARE @FlagControlaStock BIT = (SELECT T.N.value('FlagControlarStock[1]','BIT') FROM @XMLPedido.nodes('/ArchivoPlanoPedido') AS T(N));
		DECLARE @FlagGenerarVale BIT = (SELECT T.N.value('FlagGenerarVale[1]','BIT') FROM @XMLPedido.nodes('/ArchivoPlanoPedido') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT FlagBorrador FROM ERP.Pedido WHERE ID = @IdPedido)
		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLPedido.nodes('/ArchivoPlanoPedido') AS T(N)) = 0 ) 
			BEGIN
				------========= SE GENERAN EL CORRELATIVO DEL COMPROBANTE =========------
				IF ((SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLPedido.nodes('/ArchivoPlanoPedido') AS T(N)) = '' OR
				(SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLPedido.nodes('/ArchivoPlanoPedido') AS T(N)) IS NULL OR
				(SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLPedido.nodes('/ArchivoPlanoPedido') AS T(N)) = '00000000')
				BEGIN
					SET @Documento = (SELECT [ERP].[GenerarDocumentoPedido](@Serie,@IdPedido,@IdEmpresa));
				END
				ELSE
				BEGIN
					SET @Documento = (SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @XMLPedido.nodes('/ArchivoPlanoPedido') AS T(N));
				END

				SET @SerieDocumentoComprobante = @Serie + '-'+@Documento

				SET @SerieDocumentoComprobanteSunat = @SerieDocumentoComprobante
				----===============================================================-------
			END
		
		IF @FlagBorrador = 0
			BEGIN
				SET @Documento =  (SELECT Documento FROM ERP.Pedido WHERE ID = @IdPedido)
			END

		------========= SE MODIFICA COMPROBANTE CABECERA =========------

		UPDATE ERP.Pedido 
		SET Documento		=	@Documento,
			Serie			=	T.N.value('Serie[1]',					'VARCHAR(4)'),
			IdCliente		=	CASE WHEN (T.N.value('IdCliente[1]',    'INT') = 0) THEN
									NULL
								ELSE 
									T.N.value('IdCliente[1]',			'INT')
								END,
			IdEstablecimientoCliente		=	CASE WHEN (T.N.value('IdEstablecimientoCliente[1]',    'INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdEstablecimientoCliente[1]',			'INT')
			END,
			EstablecimientoDestino = CASE WHEN (T.N.value('EstablecimientoDestino[1]',	'VARCHAR(250)') = '') THEN
										NULL
									ELSE 
										T.N.value('EstablecimientoDestino[1]',			'VARCHAR(250)')
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
			IdVendedor		= 	CASE WHEN (T.N.value('IdVendedor[1]',	'INT') = 0) THEN
									NULL
								ELSE 
									T.N.value('IdVendedor[1]',			'INT')
								END,
			IdAlmacen		=	T.N.value('IdAlmacen[1]',				'INT'),
			IdMoneda		=	T.N.value('IdMoneda[1]',				'INT'),
			IdDetraccion	=	CASE WHEN (T.N.value('IdDetraccion[1]',				'INT') = 0) THEN
										NULL
									ELSE 
										T.N.value('IdDetraccion[1]',				'INT')
									END,
			IdListaPrecio	=	T.N.value('IdListaPrecio[1]',			'INT'),
			Fecha			=	T.N.value('Fecha[1]',					'DATETIME'),
			FechaVencimiento=	T.N.value('FechaVencimiento[1]',		'DATETIME'),
			DiasVencimiento	=	T.N.value('DiasVencimiento[1]',			'INT'),
			Observacion		=	T.N.value('Observacion[1]',				'VARCHAR(250)'),
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
			UsuarioModifico =   T.N.value('UsuarioModifico[1]',			'VARCHAR(250)'),
			FechaModificado =   @FechaActual
		FROM @XMLPedido.nodes('/ArchivoPlanoPedido')	AS T(N)
		WHERE ID = @IdPedido

		----===============================================================-------
		------========= SE INSERTA COMPROBANTE DETALLE =========------

		DELETE FROM [ERP].[PedidoDetalle] WHERE IdPedido = @IdPedido

		INSERT INTO [ERP].[PedidoDetalle]
		(
			IdPedido
		,IdProducto
		,Nombre
		--,NumeroLote
		--,Fecha
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
	@IdPedido												AS IdComprobante,
	T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
	T.N.value('Nombre[1]'					,'VARCHAR(MAX)')	AS Nombre,
	--T.N.value('NumeroLote[1]'					,'VARCHAR(20)')	AS NumeroLote,
	--T.N.value('Fecha[1]'					,'DATETIME')		AS Fecha,
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
	DATEADD(HOUR, 3, GETDATE())									AS FechaRegistro
	FROM @XMLPedido.nodes('/ListaArchivoPlanoPedidoDetalle/ArchivoPlanoPedidoDetalle') AS T(N)	

		----===============================================================-------

		------========= SE INSERTA COMPROBANTE REFERENCIA =========------

		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLPedido.nodes('/ArchivoPlanoPedido') AS T(N)) = 0)
		BEGIN
			UPDATE C SET
					C.IdCotizacionEstado = 2 --EMITIDO
			FROM ERP.Cotizacion C
			INNER JOIN ERP.PedidoReferencia PR ON PR.IdReferencia = C.ID
			WHERE PR.IdReferenciaOrigen = 2 AND PR.IdPedido = @IdPedido 
		END


		DELETE FROM [ERP].[PedidoReferencia] WHERE IdPedido = @IdPedido
			
		INSERT INTO [ERP].[PedidoReferencia]
				(
					IdPedido
					,IdReferenciaOrigen
					,IdReferencia
					,IdTipoComprobante
					,Serie
					,Documento
					,FlagInterno
				)
			SELECT
			@IdPedido										AS IdComprobante,
			CASE WHEN (T.N.value('IdReferenciaOrigen[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdReferenciaOrigen[1]',			'INT')
			END													AS IdReferenciaOrigen,
			T.N.value('IdReferencia[1]'	,'INT')					AS IdReferencia,
			T.N.value('IdTipoComprobante[1]'	,'INT')			AS IdTipoComprobante,
			T.N.value('Serie[1]'	,'VARCHAR(4)')				AS Serie,
			T.N.value('Documento[1]'	,'VARCHAR(30)')			AS Documento,
			T.N.value('FlagInterno[1]'	,'BIT')				AS FlagInterno
			FROM @XMLPedido.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia') AS T(N)

		IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLPedido.nodes('/ArchivoPlanoPedido') AS T(N)) = 0)
		BEGIN
			UPDATE C SET
					C.IdCotizacionEstado = 4 --IMPORTADO
			FROM ERP.Cotizacion C
			INNER JOIN ERP.PedidoReferencia PR ON PR.IdReferencia = C.ID
			WHERE PR.IdReferenciaOrigen = 2 AND PR.IdPedido = @IdPedido 
		END

		----===============================================================-------

		SELECT @IdPedido
END