CREATE PROC [ERP].[Usp_Ins_Importacion]
@IdEmpresa INT,
@IdAlmacen INT,
@IdMoneda INT,
@IdProyecto INT,
@Observacion VARCHAR(250),
@Fecha DATETIME,
@FechaVale DATETIME,
@UsuarioRegistro VARCHAR(250),
@FechaRegistro DATETIME,
@FlagBorrador BIT,
@Flag BIT,
----------
@XMLListaImportacionReferencia XML,
@XMLListaImportacionProductoDetalle XML,
@XMLListaImportacionServicioDetalle XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000

	DECLARE @ID_IMPORTACION INT;

	BEGIN -- REGISTRAR 
		
		INSERT INTO [ERP].[Importacion]
			   ([IdEmpresa]
			   ,[IdAlmacen]
			   ,[IdMoneda]
			   ,[IdProyecto]
			   ,[Observacion]
			   ,[Fecha]
			   ,[FechaVale]
			   ,[UsuarioRegistro]
			   ,[FechaRegistro]
			   ,[FlagBorrador]
			   ,[Flag])
		 VALUES
			   (@IdEmpresa,
			   (CASE @IdAlmacen WHEN 0 THEN NULL ELSE @IdAlmacen END),
			   (CASE @IdMoneda WHEN 0 THEN NULL ELSE @IdMoneda END),
			   (CASE @IdProyecto WHEN 0 THEN NULL ELSE @IdProyecto END),
			   @Observacion,
			   @Fecha,
			   @FechaVale,
			   @UsuarioRegistro,
			   @FechaRegistro,
			   @FlagBorrador,
			   @Flag);

		SET @ID_IMPORTACION = CAST(SCOPE_IDENTITY() AS int);

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
			@ID_IMPORTACION,
			(CASE T.N.value('IdReferenciaOrigen[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdReferenciaOrigen[1]', 'INT') END),
			(CASE T.N.value('IdReferencia[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdReferencia[1]', 'INT') END),
			(CASE T.N.value('IdTipoComprobante[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdTipoComprobante[1]', 'INT') END),
			T.N.value('Serie[1]', 'VARCHAR(20)'),
			T.N.value('Documento[1]', 'VARCHAR(20)'),
			1
		FROM 
		@XMLListaImportacionReferencia.nodes('/ImportacionReferencia') AS T(N)

	END

	BEGIN -- INSERTAR DESTINO 

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
			@ID_IMPORTACION,
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
			@ID_IMPORTACION,
			(CASE T.N.value('IdImportacionServicio[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdImportacionServicio[1]', 'INT') END),
			T.N.value('TipoCambio[1]', 'DECIMAL(18,5)'),
			T.N.value('Soles[1]', 'DECIMAL(18,5)'),
			T.N.value('Dolares[1]', 'DECIMAL(18,5)')
		FROM 
		@XMLListaImportacionServicioDetalle.nodes('/ImportacionServicioDetalle') AS T(N)

	END

	SELECT @ID_IMPORTACION
END