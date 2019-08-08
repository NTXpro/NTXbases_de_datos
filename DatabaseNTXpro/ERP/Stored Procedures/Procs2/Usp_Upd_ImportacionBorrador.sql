CREATE PROCEDURE [ERP].[Usp_Upd_ImportacionBorrador]
@ID INT,
@IdEmpresa INT,
@IdAlmacen INT,
@IdMoneda INT,
@IdProyecto INT,
@Observacion VARCHAR(250),
@Fecha DATETIME,
@FechaVale DATETIME,
----------
@XMLListaImportacionReferencia XML,
@XMLListaImportacionProductoDetalle XML,
@XMLListaImportacionServicioDetalle XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000

	BEGIN -- ACTUALIZAR

		UPDATE [ERP].[Importacion] SET
		[IdEmpresa] = @IdEmpresa,
		[IdAlmacen] = @IdAlmacen,
		[IdMoneda] = @IdMoneda,
		[IdProyecto] = (CASE @IdProyecto WHEN 0 THEN NULL ELSE @IdProyecto END),
		[Observacion] = @Observacion,
		[Fecha] = @Fecha,
		[FechaVale] = @FechaVale,
		[FlagBorrador] = 1
		WHERE ID = @ID

	END

	BEGIN -- ELIMINAR DETALLE

		DELETE FROM [ERP].[ImportacionReferencia] WHERE IdImportacion = @ID
		DELETE FROM [ERP].[ImportacionProductoDetalle] WHERE IdImportacion = @ID
		DELETE FROM [ERP].[ImportacionServicioDetalle] WHERE IdImportacion = @ID

	END

	BEGIN -- INSERTAR REFERENCIA
		
		INSERT INTO [ERP].[ImportacionReferencia]
			   ([IdImportacion]
			   ,[IdReferenciaOrigen]
			   ,[IdReferencia]
			   ,[IdTipoComprobante]
			   ,[Serie]
			   ,[Documento]
			   ,[FlagInterno])
		SELECT 
			@ID,
			(CASE T.N.value('IdReferenciaOrigen[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdReferenciaOrigen[1]', 'INT') END),
			(CASE T.N.value('IdReferencia[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdReferencia[1]', 'INT') END),
			(CASE T.N.value('IdTipoComprobante[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdTipoComprobante[1]', 'INT') END),
			T.N.value('Serie[1]', 'VARCHAR(20)'),
			T.N.value('Documento[1]', 'VARCHAR(20)'),
			1
		FROM 
		@XMLListaImportacionReferencia.nodes('/ImportacionReferencia') AS T(N)

	END

	BEGIN -- INSERTAR PRODUCTO 

		INSERT INTO [ERP].[ImportacionProductoDetalle]
			   ([IdImportacion]
			   ,[IdOrdenCompra]
			   ,[IdProducto]
			   ,[Fecha]
			   ,[Lote]
			   ,[Cantidad]
			   ,[PrecioUnitario]
			   ,[Total]
			   ,[PrecioUnitarioCosteo]
			   ,[TotalCosteo])
		SELECT 
			@ID,
			(CASE T.N.value('IdOrdenCompra[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdOrdenCompra[1]', 'INT') END),
			(CASE T.N.value('IdProducto[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdProducto[1]', 'INT') END),
			CONVERT(DATETIME, T.N.value('FechaStr[1]', 'VARCHAR(50)'), 103),
			T.N.value('Lote[1]', 'VARCHAR(50)'),
			T.N.value('Cantidad[1]', 'DECIMAL(18,5)'),
			T.N.value('PrecioUnitario[1]', 'DECIMAL(18,5)'),
			T.N.value('Total[1]', 'DECIMAL(18,5)'),
			T.N.value('PrecioUnitarioCosteo[1]', 'DECIMAL(18,5)'),
			T.N.value('TotalCosteo[1]', 'DECIMAL(18,5)')
		FROM 
		@XMLListaImportacionProductoDetalle.nodes('/ImportacionProductoDetalle') AS T(N)

	END

	BEGIN -- INSERTAR SERVICIO 

		INSERT INTO [ERP].[ImportacionServicioDetalle]
			   ([IdImportacion]
			   ,[IdImportacionServicio]
			   ,[TipoCambio]
			   ,[Soles]
			   ,[Dolares])
		SELECT 
			@ID,
			(CASE T.N.value('IdImportacionServicio[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdImportacionServicio[1]', 'INT') END),
			T.N.value('TipoCambio[1]', 'DECIMAL(18,5)'),
			T.N.value('Soles[1]', 'DECIMAL(18,5)'),
			T.N.value('Dolares[1]', 'DECIMAL(18,5)')
		FROM 
		@XMLListaImportacionServicioDetalle.nodes('/ImportacionServicioDetalle') AS T(N)

	END

	SELECT @ID;
END