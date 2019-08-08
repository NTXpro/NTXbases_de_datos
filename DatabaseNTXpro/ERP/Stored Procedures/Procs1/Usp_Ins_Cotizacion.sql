CREATE PROCEDURE [ERP].[Usp_Ins_Cotizacion]
@IdCotizacion	 INT OUTPUT,
@XMLCotizacion	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

		INSERT INTO ERP.Cotizacion(
									 IdEmpresa
									,IdTipoComprobante
									,IdCliente
									,IdEstablecimientoCliente
									,IdProyecto
									,IdDetraccion
									,IdVendedor
									,IdEstablecimiento
									,IdAlmacen
									,IdMoneda
									,IdListaPrecio
									,IdCotizacionEstado
									,Serie
									,Documento
									,Fecha
									,FechaVencimiento
									,DiasVencimiento
									,Observacion
									,TipoCambio
									,PorcentajeIGV
									,PorcentajeDescuento
									,PorcentajePercepcion
									,PorcentajeDetraccion
									,TotalDetalleISC
									,TotalDetalleAfecto
									,TotalDetalleInafecto
									,TotalDetalleExportacion
									,TotalDetalleGratuito
									,TotalDetalle
									,ImporteDescuento
									,SubTotal
									,IGV
									,Total
									,ImportePercepcion
									,TotalPercepcion
									,ImporteDetraccion
									,TotalDetraccion
									,UsuarioRegistro
									,FechaRegistro
									,FlagExportacion
									,FlagPercepcion
									,FlagDetraccion
									,FlagAnticipo
									,FlagBorrador
									,Flag
									) 
		SELECT
			T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
			T.N.value('IdTipoComprobante[1]',	'INT')				AS IdTipoComprobante,
			CASE WHEN (T.N.value('IdCliente[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdCliente[1]',			'INT')
			END														AS IdCliente,
			CASE WHEN (T.N.value('IdEstablecimientoCliente[1]',	'INT') = 0) THEN
									NULL
			ELSE 
				T.N.value('IdEstablecimientoCliente[1]',			'INT')
			END														AS IdEstablecimientoCliente,									
			CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdProyecto[1]',			'INT')
			END														AS IdProyecto,
			CASE WHEN (T.N.value('IdDetraccion[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdDetraccion[1]',			'INT')
			END														AS IdDetraccion,
			CASE WHEN (T.N.value('IdVendedor[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdVendedor[1]',			'INT')
			END														AS IdVendedor,
			CASE WHEN (T.N.value('IdEstablecimiento[1]',	'INT') = 0) THEN
									NULL
			ELSE 
				T.N.value('IdEstablecimiento[1]',			'INT')
			END														AS IdEstablecimiento,
			T.N.value('IdAlmacen[1]',			'INT')				AS IdAlmacen,
			T.N.value('IdMoneda[1]',			'INT')				AS IdMoneda,
			T.N.value('IdListaPrecio[1]',		'INT')				AS IdListaPrecio,
			T.N.value('IdCotizacionEstado[1]',	'INT')				AS IdCotizacionEstado,
			T.N.value('Serie[1]',				'CHAR(4)')			AS Serie,
			T.N.value('Documento[1]',			'VARCHAR(20)')		AS Documento,
			T.N.value('Fecha[1]',				'DATETIME')			AS Fecha,
			T.N.value('FechaVencimiento[1]',	'DATETIME')			AS FechaVencimiento,
			T.N.value('DiasVencimiento[1]',		'INT')				AS DiasVencimiento,
			T.N.value('Observacion[1]',			'VARCHAR(250)')		AS Observacion,
			T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,
			T.N.value('PorcentajeIGV[1]',		'DECIMAL(14,5)')	AS PorcentajeIGV,
			T.N.value('PorcentajeDescuento[1]',	'DECIMAL(14,5)')	AS PorcentajeDescuento,
			T.N.value('PorcentajePercepcion[1]',	'DECIMAL(14,5)')AS PorcentajePercepcion,
			T.N.value('PorcentajeDetraccion[1]',	'DECIMAL(14,5)')AS PorcentajeDetraccion,
			T.N.value('TotalDetalleISC[1]',	'DECIMAL(14,5)')		AS TotalDetalleISC,
			T.N.value('TotalDetalleAfecto[1]',	'DECIMAL(14,5)')	AS TotalDetalleAfecto,
			T.N.value('TotalDetalleInafecto[1]','DECIMAL(14,5)')	AS TotalDetalleInafecto,
			T.N.value('TotalDetalleExportacion[1]','DECIMAL(14,5)')	AS TotalDetalleExportacion,
			T.N.value('TotalDetalleGratuito[1]','DECIMAL(14,5)')	AS TotalDetalleGratuito,
			T.N.value('TotalDetalle[1]',		'DECIMAL(14,5)')	AS TotalDetalle,
			T.N.value('ImporteDescuento[1]',	'DECIMAL(14,5)')	AS ImporteDescuento,
			T.N.value('SubTotal[1]',			'DECIMAL(14,5)')	AS SubTotal,
			T.N.value('IGV[1]',					'DECIMAL(14,5)')	AS IGV,
			T.N.value('Total[1]',				'DECIMAL(14,5)')	AS Total,
			T.N.value('ImportePercepcion[1]',	'DECIMAL(14,5)')	AS ImportePercepcion,
			T.N.value('TotalPercepcion[1]',	'DECIMAL(14,5)')		AS TotalPercepcion,
			T.N.value('ImporteDetraccion[1]',	'DECIMAL(14,5)')	AS ImporteDetraccion,
			T.N.value('TotalDetraccion[1]',	'DECIMAL(14,5)')		AS TotalDetraccion,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
			@FechaActual											AS FechaRegistro,
			T.N.value('FlagExportacion[1]',		'BIT')				AS FlagExportacion,
			T.N.value('FlagPercepcion[1]',		'BIT')				AS FlagPercepcion,
			T.N.value('FlagDetraccion[1]',		'BIT')				AS FlagDetraccion,
			T.N.value('FlagAnticipo[1]',		'BIT')				AS FlagAnticipo,
			T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador,
			CAST(1 AS BIT)											AS Flag
		FROM @XMLCotizacion.nodes('/ArchivoPlanoCotizacion')	AS T(N)
		SET @IdCotizacion = SCOPE_IDENTITY()


		INSERT INTO [ERP].[CotizacionDetalle]
		 (
			 IdCotizacion
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
		@IdCotizacion												AS IdComprobante,
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
		FROM @XMLCotizacion.nodes('/ListaArchivoPlanoCotizacionDetalle/ArchivoPlanoCotizacionDetalle') AS T(N)	

		--IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLCotizacion.nodes('/ArchivoPlanoCotizacion') AS T(N)) = 0)
		--BEGIN
		--	UPDATE R SET
		--			R.IdGuiaRemisionEstado = 2 --EMITIDO
		--	FROM ERP.GuiaRemision R
		--	INNER JOIN ERP.ComprobanteReferencia CR ON CR.IdReferencia = R.ID
		--	WHERE CR.IdReferenciaOrigen = 3 AND CR.IdComprobante = @IdComprobante 
		--END

		INSERT INTO [ERP].[CotizacionReferencia]
		 (
			   IdCotizacion
			  ,IdReferenciaOrigen
			  ,IdReferencia
			  ,IdTipoComprobante
			  ,Serie
			  ,Documento
			  ,FlagInterno
		 )
		SELECT
		@IdCotizacion										AS IdComprobante,
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
		FROM @XMLCotizacion.nodes('/ListaArchivoPlanoComprobanteReferencia/ArchivoPlanoComprobanteReferencia') AS T(N)

		--IF((SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLComprobante.nodes('/ArchivoPlanoComprobante') AS T(N)) = 0)
		--BEGIN
		--	UPDATE R SET
		--			R.IdGuiaRemisionEstado = 4 --IMPORTADO
		--	FROM ERP.GuiaRemision R
		--	INNER JOIN ERP.ComprobanteReferencia CR ON CR.IdReferencia = R.ID
		--	WHERE CR.IdReferenciaOrigen = 3 AND CR.IdComprobante = @IdComprobante 
		--END


		SET NOCOUNT OFF;
END