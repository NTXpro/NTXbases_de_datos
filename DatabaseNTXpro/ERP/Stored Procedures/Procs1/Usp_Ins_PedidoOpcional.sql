CREATE PROC [ERP].[Usp_Ins_PedidoOpcional]

@IdMoneda INT,
@TipoCambio DECIMAL (14,5),
@Fecha DATETIME,
@IdAlmacen INT,
@Serie VARCHAR(20),
@IdEmpresa INT,
@Total DECIMAL(14,5),
@SubTotal DECIMAL (14,5),
@IGV DECIMAL (14,5),
@FechaVencimiento DATETIME,
@IdListaPrecio INT,
@ListaPedidoDetalle XML



AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	DECLARE @Documento VARCHAR(20) = NULL
	
		

   
	DECLARE @IdPedido INT;


		INSERT INTO ERP.Pedido(
									 IdEmpresa
									,IdTipoComprobante
									,IdCliente
									,IdEstablecimientoCliente
									,EstablecimientoDestino
									,IdProyecto
									,IdDetraccion
									,IdVendedor
									,IdEstablecimiento
									,IdAlmacen
									,IdMoneda
									,IdListaPrecio
									,IdPedidoEstado
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
			199	AS IdTipoComprobante,
			CASE WHEN (T.N.value('IdCliente[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdCliente[1]',			'INT')
			END														AS IdCliente,
				CASE WHEN (T.N.value('IdEstablecimientoCliente[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdEstablecimientoCliente[1]',			'INT')
			END														AS IdEstablecimientoCliente,
			CASE WHEN (T.N.value('EstablecimientoDestino[1]','VARCHAR(250)') = '') THEN
				NULL
			ELSE 
				T.N.value('EstablecimientoDestino[1]',			'VARCHAR(250)')
			END														AS EstablecimientoDestino,
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
				471
			END														AS IdEstablecimiento,
		    @IdAlmacen		AS IdAlmacen,
		    @IdMoneda as IdMoneda,
			@IdListaPrecio as IdListaPrecio,
			2 AS IdPedidoEstado,
			@Serie		AS Serie,
			@Documento			AS Documento,
			@Fecha		AS Fecha,
			@FechaVencimiento		AS FechaVencimiento,
			T.N.value('DiasVencimiento[1]',		'INT')				AS DiasVencimiento,
			T.N.value('Observacion[1]',			'VARCHAR(250)')		AS Observacion,
			@TipoCambio	AS TipoCambio,
			T.N.value('PorcentajeIGV[1]',		'DECIMAL(14,5)')	AS PorcentajeIGV,
			T.N.value('PorcentajeDescuento[1]',	'DECIMAL(14,5)')	AS PorcentajeDescuento,
			T.N.value('PorcentajePercepcion[1]',	'DECIMAL(14,5)')AS PorcentajePercepcion,
			T.N.value('PorcentajeDetraccion[1]',	'DECIMAL(14,5)')AS PorcentajeDetraccion,
			T.N.value('TotalDetalleISC[1]',	'DECIMAL(14,5)')		AS TotalDetalleISC,
			T.N.value('TotalDetalleAfecto[1]',	'DECIMAL(14,5)')	AS TotalDetalleAfecto,
			T.N.value('TotalDetalleInafecto[1]','DECIMAL(14,5)')	AS TotalDetalleInafecto,
			T.N.value('TotalDetalleExportacion[1]','DECIMAL(14,5)')	AS TotalDetalleExportacion,
			T.N.value('TotalDetalleGratuito[1]','DECIMAL(14,5)')	AS TotalDetalleGratuito,
			@SubTotal	AS TotalDetalle,
			T.N.value('ImporteDescuento[1]',	'DECIMAL(14,5)')	AS ImporteDescuento,
			@SubTotal	AS SubTotal,
			@IGV	AS IGV,
			@Total	AS Total,
			T.N.value('ImportePercepcion[1]',	'DECIMAL(14,5)')	AS ImportePercepcion,
			T.N.value('TotalPercepcion[1]',	'DECIMAL(14,5)')		AS TotalPercepcion,
			T.N.value('ImporteDetraccion[1]',	'DECIMAL(14,5)')	AS ImporteDetraccion,
			T.N.value('TotalDetraccion[1]',	'DECIMAL(14,5)')		AS TotalDetraccion,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
			@Fecha											AS FechaRegistro,
			T.N.value('FlagExportacion[1]',		'BIT')				AS FlagExportacion,
			T.N.value('FlagPercepcion[1]',		'BIT')				AS FlagPercepcion,
			T.N.value('FlagDetraccion[1]',		'BIT')				AS FlagDetraccion,
			T.N.value('FlagAnticipo[1]',		'BIT')				AS FlagAnticipo,
			T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador,
			CAST(1 AS BIT)											AS Flag
		FROM @ListaPedidoDetalle.nodes('/ListaPedidoDetalle/PedidoDetalle')	AS T(N)
		SET @IdPedido = SCOPE_IDENTITY()



		IF ((SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @ListaPedidoDetalle.nodes('/ListaPedidoDetalle/PedidoDetalle') AS T(N)) = '' OR
				(SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @ListaPedidoDetalle.nodes('/ListaPedidoDetalle/PedidoDetalle') AS T(N)) IS NULL OR
				(SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @ListaPedidoDetalle.nodes('/ListaPedidoDetalle/PedidoDetalle') AS T(N)) = '00000000')
				BEGIN
					SET @Documento = (SELECT [ERP].[GenerarDocumentoPedido](@Serie,@IdPedido,@IdEmpresa));
				END
				ELSE
				BEGIN
					SET @Documento = (SELECT T.N.value('Documento[1]','VARCHAR(20)') FROM @ListaPedidoDetalle.nodes('/ListaPedidoDetalle/PedidoDetalle') AS T(N));
				END

	update ERP.Pedido SET Documento = @Documento, SerieDocumento = @Serie + '-' + @Documento
		 where ID = @IdPedido
			--BEGIN
			--	SET @Documento =  (SELECT Documento FROM ERP.Pedido WHERE ID = @IdPedido)	
			--END

			
		

	INSERT INTO [ERP].[PedidoDetalle]
		 (
			 IdPedido
			,IdProducto
			,Nombre
		
		
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
		@IdPedido,
		T.N.value('IdProducto[1]'	,'INT')				AS IdProducto,
		
		T.N.value('Nombre[1]'					,'VARCHAR(50)')	AS Cantidad,
	
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
		FROM @ListaPedidoDetalle.nodes('/ListaPedidoDetalle/PedidoDetalle') AS T(N)	
	select @IdPedido
	

END