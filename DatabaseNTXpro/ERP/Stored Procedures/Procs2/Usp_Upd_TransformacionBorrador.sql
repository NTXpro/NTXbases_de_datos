CREATE PROCEDURE [ERP].[Usp_Upd_TransformacionBorrador]
@ID INT,
@IdAlmacenOrigen INT,
@IdAlmacenDestino INT,
@IdMoneda INT,
@IdProyecto INT,
@Observaciones VARCHAR(250),
@Fecha DATETIME,
@FechaIngreso DATETIME,
@FechaSalida DATETIME,
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

	BEGIN -- ACTUALIZAR

		UPDATE [ERP].[Transformacion] SET
		[IdAlmacenOrigen] = @IdAlmacenOrigen,
		[IdAlmacenDestino] = @IdAlmacenDestino,
		[IdMoneda] = @IdMoneda,
		[IdProyecto] = (CASE @IdProyecto WHEN 0 THEN NULL ELSE @IdProyecto END),
		[Observaciones] = @Observaciones,
		[Fecha] = @Fecha,
		[FechaIngreso] = @FechaIngreso,
		[FechaSalida] = @FechaSalida,
		[FlagBorrador] = 1,
		[Flag] = 1,
		[PorcentajeIGV] = @PorcentajeIGV
		WHERE ID = @ID

	END

	BEGIN -- ELIMINAR DETALLE

		DELETE FROM [ERP].[TransformacionOrigenDetalle] WHERE IdTransformacion = @ID
		DELETE FROM [ERP].[TransformacionMermaDetalle] WHERE IdTransformacion = @ID
		DELETE FROM [ERP].[TransformacionServicioDetalle] WHERE IdTransformacion = @ID
		DELETE FROM [ERP].[TransformacionDestinoDetalle] WHERE IdTransformacion = @ID

	END

	BEGIN -- INSERTAR ORIGEN (DESPUES DE ELIMINARLOS) 

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
			@ID,
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

	BEGIN -- INSERTAR MERMA (DESPUES DE ELIMINARLOS)

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
			@ID,
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

	BEGIN -- INSERTAR SERVICIO (DESPUES DE ELIMINARLOS)

		INSERT INTO [ERP].[TransformacionServicioDetalle]
			   ([IdTransformacion]
			   ,[IdTransformacionServicio]
			   ,[Cantidad]
			   ,[PrecioUnitario]
			   ,[Total])
		SELECT 
			@ID,
			(CASE T.N.value('IdTransformacionServicio[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdTransformacionServicio[1]', 'INT') END),
			T.N.value('Cantidad[1]', 'DECIMAL(18,5)'),
			T.N.value('PrecioUnitario[1]', 'DECIMAL(18,5)'),
			T.N.value('Total[1]', 'DECIMAL(18,5)')
		FROM 
		@XMLListaTransformacionServicioDetalle.nodes('/TransformacionServicioDetalle') AS T(N)

	END

	BEGIN -- INSERTAR DESTINO (DESPUES DE ELIMINARLOS)

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
			@ID,
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

	SELECT @ID;
END
