CREATE PROC [ERP].[Usp_Ins_Transformacion]
@IdEmpresa INT,
@IdAlmacenOrigen INT,
@IdAlmacenDestino INT,
@IdMoneda INT,
@IdProyecto INT,
@Observaciones VARCHAR(250),
@Fecha DATETIME,
@FechaIngreso DATETIME,
@FechaSalida DATETIME,
@IdValeIngreso INT,
@IdValeSalida INT,
@UsuarioRegistro VARCHAR(250),
@FechaRegistro DATETIME,
@FlagBorrador BIT,
@Flag BIT,
@PorcentajeIGV DECIMAL(18,2) = 0.00,
----------
@XMLListaTransformacionOrigenDetalle XML,
@XMLListaTransformacionMermaDetalle XML,
@XMLListaTransformacionServicioDetalle XML,
@XMLListaTransformacionDestinoDetalle XML,
@XMLValeIngreso XML,
@XMLValeSalida XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000

	DECLARE @ID_TRANSFORMACION INT;

	BEGIN -- REGISTRAR 
		
		INSERT INTO [ERP].[Transformacion]
			   ([IdEmpresa]
			   ,[IdAlmacenOrigen]
			   ,[IdAlmacenDestino]
			   ,[IdMoneda]
			   ,[IdProyecto]
			   ,[Observaciones]
			   ,[Fecha]
			   ,[FechaIngreso]
			   ,[FechaSalida]
			   ,[UsuarioRegistro]
			   ,[FechaRegistro]
			   ,[FlagBorrador]
			   ,[Flag]
			   ,[PorcentajeIGV])
		 VALUES
			   (@IdEmpresa,
			   (CASE @IdAlmacenOrigen WHEN 0 THEN NULL ELSE @IdAlmacenOrigen END),
			   (CASE @IdAlmacenDestino WHEN 0 THEN NULL ELSE @IdAlmacenDestino END),
			   (CASE @IdMoneda WHEN 0 THEN NULL ELSE @IdMoneda END),
			   (CASE @IdProyecto WHEN 0 THEN NULL ELSE @IdProyecto END),
			   @Observaciones,
			   @Fecha,
			   @FechaIngreso,
			   @FechaSalida,
			   @UsuarioRegistro,
			   @FechaRegistro,
			   @FlagBorrador,
			   @Flag,
			   @PorcentajeIGV);

		SET @ID_TRANSFORMACION = CAST(SCOPE_IDENTITY() AS int);

	END

	BEGIN -- INSERTAR ORIGEN 

		INSERT INTO [ERP].[TransformacionOrigenDetalle]
			   ([IdTransformacion]
			   ,[IdProducto]
			   ,[Lote]
			   ,[FlagAfecto]
			   ,[Cantidad]
			   ,[PrecioUnitario]
			   ,[SubTotal]
			   ,[IGV]
			   ,[Total])
		SELECT 
			@ID_TRANSFORMACION,
			(CASE T.N.value('IdProducto[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdProducto[1]', 'INT') END),
			T.N.value('Lote[1]', 'VARCHAR(50)'),
			T.N.value('FlagAfecto[1]', 'BIT'),
			T.N.value('Cantidad[1]', 'DECIMAL(18,5)'),
			T.N.value('PrecioUnitario[1]', 'DECIMAL(18,5)'),
			T.N.value('SubTotal[1]', 'DECIMAL(18,5)'),
			T.N.value('IGV[1]', 'DECIMAL(18,5)'),
			T.N.value('Total[1]', 'DECIMAL(18,5)')
		FROM 
		@XMLListaTransformacionOrigenDetalle.nodes('/TransformacionOrigenDetalle')	AS T(N)

	END

	BEGIN -- INSERTAR MERMA 

		INSERT INTO [ERP].[TransformacionMermaDetalle]
			   ([IdTransformacion]
			   ,[IdProducto]
			   ,[Lote]
			   ,[FlagAfecto]
			   ,[Cantidad]
			   ,[PrecioUnitario]
			   ,[SubTotal]
			   ,[IGV]
			   ,[Total])
		SELECT 
			@ID_TRANSFORMACION,
			(CASE T.N.value('IdProducto[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdProducto[1]', 'INT') END),
			T.N.value('Lote[1]', 'VARCHAR(50)'),
			T.N.value('FlagAfecto[1]', 'BIT'),
			T.N.value('Cantidad[1]', 'DECIMAL(18,5)'),
			T.N.value('PrecioUnitario[1]', 'DECIMAL(18,5)'),
			T.N.value('SubTotal[1]', 'DECIMAL(18,5)'),
			T.N.value('IGV[1]', 'DECIMAL(18,5)'),
			T.N.value('Total[1]', 'DECIMAL(18,5)')
		FROM 
		@XMLListaTransformacionMermaDetalle.nodes('/TransformacionMermaDetalle') AS T(N)

	END

	BEGIN -- INSERTAR SERVICIO 

		INSERT INTO [ERP].[TransformacionServicioDetalle]
			   ([IdTransformacion]
			   ,[IdTransformacionServicio]
			   ,[Cantidad]
			   ,[PrecioUnitario]
			   ,[Total])
		SELECT 
			@ID_TRANSFORMACION,
			(CASE T.N.value('IdTransformacionServicio[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdTransformacionServicio[1]', 'INT') END),
			T.N.value('Cantidad[1]', 'DECIMAL(18,5)'),
			T.N.value('PrecioUnitario[1]', 'DECIMAL(18,5)'),
			T.N.value('Total[1]', 'DECIMAL(18,5)')
		FROM 
		@XMLListaTransformacionServicioDetalle.nodes('/TransformacionServicioDetalle') AS T(N)

	END

	BEGIN -- INSERTAR DESTINO 

		INSERT INTO [ERP].[TransformacionDestinoDetalle]
			   ([IdTransformacion]
			   ,[IdProducto]
			   ,[Fecha]
			   ,[Lote]
			   ,[FlagAfecto]
			   ,[Cantidad]
			   ,[PrecioUnitario]
			   ,[SubTotal]
			   ,[IGV]
			   ,[Total])
		SELECT 
			@ID_TRANSFORMACION,
			(CASE T.N.value('IdProducto[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdProducto[1]', 'INT') END),
			CONVERT(DATETIME, T.N.value('FechaStr[1]', 'VARCHAR(50)'), 103),
			T.N.value('Lote[1]', 'VARCHAR(50)'),
			T.N.value('FlagAfecto[1]', 'BIT'),
			T.N.value('Cantidad[1]', 'DECIMAL(18,5)'),
			T.N.value('PrecioUnitario[1]', 'DECIMAL(18,5)'),
			T.N.value('SubTotal[1]', 'DECIMAL(18,5)'),
			T.N.value('IGV[1]', 'DECIMAL(18,5)'),
			T.N.value('Total[1]', 'DECIMAL(18,5)')
		FROM 
		@XMLListaTransformacionDestinoDetalle.nodes('/TransformacionDestinoDetalle') AS T(N)

	END

	SELECT @ID_TRANSFORMACION
END
