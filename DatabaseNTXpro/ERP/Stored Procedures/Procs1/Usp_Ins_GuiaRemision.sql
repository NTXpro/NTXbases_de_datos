CREATE PROC [ERP].[Usp_Ins_GuiaRemision]
@IdGuiaRemision	 INT OUTPUT,
@XMLGuiaRemision	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		INSERT INTO ERP.GuiaRemision(
										IdTipoComprobante,
										IdEmpresa,
										IdEntidad,
										IdGuiaRemisionEstado,
										IdMoneda,
										IdEstablecimiento,
										IdChofer,
										IdTransporte,
										IdVehiculo,
										IdAlmacen,
										IdMotivoTraslado,
										IdModalidadTraslado,
										IdUnidadMedida,
										IdUbigeoOrigen,
										IdUbigeoDestino,
										IdTipoMovimiento,
										IdVendedor,
										TipoCambio,
										Fecha,
										Serie,
										Documento,
										NumeroContenedor,
										CodigoPuerto,
										Observacion,
										EstablecimientoOrigen,
										EstablecimientoDestino,
										PorcentajeIGV,
										SubTotal,
										IGV,
										Total,
										TotalPeso,
										Flag,
										FlagBorrador,
										FlagValidarStock,
										FlagGuiaElectronico,
										UsuarioRegistro,
										FechaRegistro,
										IdListaPrecio
										)
							SELECT 
									T.N.value('IdTipoComprobante[1]',			'INT')				AS IdTipoComprobante,
									T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
									CASE WHEN T.N.value('IdEntidad[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdEntidad[1]','INT') END AS IdEntidad,
									T.N.value('IdGuiaRemisionEstado[1]',			'INT')				AS IdGuiaRemisionEstado,
									T.N.value('IdMoneda[1]',			'INT')				AS IdMoneda,
									CASE WHEN T.N.value('IdEstablecimiento[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdEstablecimiento[1]','INT') END AS IdEstablecimiento,
									CASE WHEN T.N.value('IdChofer[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdChofer[1]','INT') END AS IdChofer,
									CASE WHEN T.N.value('IdTransporte[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdTransporte[1]','INT') END AS IdTransporte,
									CASE WHEN T.N.value('IdVehiculo[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdVehiculo[1]','INT') END AS IdVehiculo,
									CASE WHEN T.N.value('IdAlmacen[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdAlmacen[1]','INT') END AS IdAlmacen,
									CASE WHEN T.N.value('IdMotivoTraslado[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdMotivoTraslado[1]','INT') END AS IdMotivoTraslado,
									CASE WHEN T.N.value('IdModalidadTraslado[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdModalidadTraslado[1]','INT') END AS IdModalidadTraslado,
									CASE WHEN T.N.value('IdUnidadMedida[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdUnidadMedida[1]','INT') END AS IdUnidadMedida,
									CASE WHEN T.N.value('IdUbigeoOrigen[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdUbigeoOrigen[1]','INT') END AS IdUbigeoOrigen,
									CASE WHEN T.N.value('IdUbigeoDestino[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdUbigeoDestino[1]','INT') END AS IdUbigeoDestino,
									CASE WHEN T.N.value('IdTipoMovimiento[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdTipoMovimiento[1]','INT') END AS IdTipoMovimiento,
									CASE WHEN T.N.value('IdVendedor[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdVendedor[1]','INT') END AS IdVendedor,
									T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')				AS TipoCambio,
									T.N.value('Fecha[1]',			'DATETIME')				AS Fecha,
									T.N.value('Serie[1]',			'VARCHAR(10)')				AS Serie,
									T.N.value('Documento[1]',			'VARCHAR(10)')				AS Documento,
									T.N.value('NumeroContenedor[1]',			'VARCHAR(10)')				AS NumeroContenedor,
									T.N.value('CodigoPuerto[1]',			'VARCHAR(10)')				AS CodigoPuerto,
									T.N.value('Observacion[1]',			'VARCHAR(250)')				AS Observacion,
									T.N.value('EstablecimientoOrigen[1]',			'VARCHAR(250)')				AS EstablecimientoOrigen,
									T.N.value('EstablecimientoDestino[1]',			'VARCHAR(250)')				AS EstablecimientoDestino,
									T.N.value('PorcentajeIGV[1]',			'DECIMAL(14,5)')				AS PorcentajeIGV,
									T.N.value('SubTotal[1]',			'DECIMAL(14,5)')				AS SubTotal,
									T.N.value('IGV[1]',			'DECIMAL(14,5)')				AS IGV,
									T.N.value('Total[1]',			'DECIMAL(14,5)')				AS Total,
									T.N.value('TotalPeso[1]',			'DECIMAL(14,5)')				AS TotalPeso,
									T.N.value('Flag[1]',			'BIT')				AS Flag,
									T.N.value('FlagBorrador[1]',			'BIT')				AS FlagBorrador,
									T.N.value('FlagValidarStock[1]',			'BIT')				AS FlagValidarStock,
									T.N.value('FlagGuiaElectronico[1]',			'BIT')				AS FlagGuiaElectronico,
									T.N.value('UsuarioRegistro[1]',			'VARCHAR(250)')				AS UsuarioRegistro,
									DATEADD(HOUR, 3, GETDATE())								AS FechaRegistro,
									CASE WHEN T.N.value('IdListaPrecio[1]',			'INT')	= 0 THEN NULL ELSE T.N.value('IdListaPrecio[1]','INT') END AS IdListaPrecio
									FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision')	AS T(N)
									SET @IdGuiaRemision = SCOPE_IDENTITY()


		INSERT INTO ERP.GuiaRemisionDetalle(
											IdGuiaRemision,
											IdProducto,
											Nombre,
											Cantidad,
											Lote,
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
											Peso,
											PesoUnitario,
											FlagAfecto
											)	
									SELECT 
											@IdGuiaRemision												AS IdGuiaRemision,
											T.N.value('IdProducto[1]'				,'INT')				AS IdProducto,
											T.N.value('Nombre[1]'					,'VARCHAR(MAX)')	AS Nombre,
											T.N.value('Cantidad[1]'					,'DECIMAL(14,5)')	AS Cantidad,
											T.N.value('Lote[1]'						,'VARCHAR(250)')	AS Lote,
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
											T.N.value('Peso[1]'						,'DECIMAL(14,5)')	AS Peso,
											T.N.value('PesoUnitario[1]'				,'DECIMAL(14,5)')	AS PesoUnitario,
											T.N.value('FlagAfecto[1]'					,'BIT')				AS FlagAfecto
											FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision/ListaArchivoPlanoGuiaRemisionDetalle/ArchivoPlanoGuiaRemisionDetalle') AS T(N)	
						
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
												T.N.value('IdReferenciaOrigen[1]'	,'INT')				AS IdCompraReferencia,
												CASE WHEN (T.N.value('IdReferencia[1]'	,'INT')	= 0) THEN NULL ELSE T.N.value('IdReferencia[1]'	,'INT')	END AS IdReferencia,
												T.N.value('IdTipoComprobante[1]'	,'INT')				AS IdTipoComprobante,
												T.N.value('Serie[1]'	,'VARCHAR(20)')					AS Serie,
												T.N.value('Documento[1]'	,'VARCHAR(20)')				AS Documento,
												T.N.value('FlagInterno[1]'	,'BIT')					AS FlagInterno
												FROM @XMLGuiaRemision.nodes('/ArchivoPlanoGuiaRemision/ListaArchivoPlanoGuiaRemisionDetalle/ArchivoPlanoComprobanteReferencia')  AS T(N)
						
						SET NOCOUNT OFF;
END
