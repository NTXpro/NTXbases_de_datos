CREATE PROCEDURE [ERP].[Usp_Upd_Transformacion]
@ID INT,
@IdEmpresa INT,
@IdMoneda INT,
@IdProyecto INT,
@Observaciones VARCHAR(250),
@Fecha DATETIME,
@FechaIngreso DATETIME,
@FechaSalida DATETIME,
@UsuarioModifico VARCHAR(250),
@FechaModificado DATETIME,
@PorcentajeIGV DECIMAL(18,2) = 0.00,
----------
@XMLListaTransformacionOrigenDetalle XML,
@XMLListaTransformacionMermaDetalle XML,
@XMLListaTransformacionServicioDetalle XML,
@XMLListaTransformacionDestinoDetalle XML,
@XMLValeIngreso XML,
@XMLValeSalida XML,
@DataResult VARCHAR(MAX) OUT
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000

	DECLARE @OPCIONAL VARCHAR(MAX) = '';
	DECLARE @ID_VALE_INGRESO INT = (SELECT IdValeIngreso FROM ERP.Transformacion WHERE ID = @ID);
	DECLARE @ID_VALE_SALIDA INT = (SELECT IdValeSalida FROM ERP.Transformacion WHERE ID = @ID);
	DECLARE @DOCUMENTO VARCHAR(10) = (SELECT [Documento] FROM [ERP].[Transformacion] WHERE ID = @ID);
	DECLARE @CONDICIO_FECHA_VALE VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'LRVCFP' AND IdEmpresa = @IdEmpresa)

	IF (@DOCUMENTO IS NULL) -- REGISTRAR / ACTUALIZAR VALE DE SALIDA (ORIGEN)
	BEGIN
		EXEC [ERP].[Usp_Ins_Vale] @ID_VALE_SALIDA OUT, @DataResult OUT, @XMLValeSalida;
	END
	ELSE
	BEGIN
		EXEC [ERP].[Usp_Upd_Vale] @ID_VALE_SALIDA, @DataResult OUT, @XMLValeSalida;
	END

	IF(LEN(@DataResult) = 0)
	BEGIN

		UPDATE [ERP].[Transformacion] SET
		[IdMoneda] = @IdMoneda,
		[IdProyecto] = (CASE @IdProyecto WHEN 0 THEN NULL ELSE @IdProyecto END),
		[Observaciones] = @Observaciones,
		[Fecha] = @Fecha,
		[UsuarioModifico] = @UsuarioModifico,
		[FechaModificado] = @FechaModificado,
		[FlagBorrador] = 0,
		[Flag] = 1,
		[PorcentajeIGV] = @PorcentajeIGV
		WHERE ID = @ID

		IF(@CONDICIO_FECHA_VALE = '1')
		BEGIN
			UPDATE [ERP].[Transformacion] SET 
			[FechaIngreso] = @FechaIngreso,
			[FechaSalida] = @FechaSalida
			WHERE ID = @ID;
		END

		IF (@DOCUMENTO IS NULL)
		BEGIN
			EXEC [ERP].[Usp_Ins_Vale] @ID_VALE_INGRESO OUT, @OPCIONAL OUT, @XMLValeIngreso;

			DECLARE @DOCUMENTO_GENERADO INT = (SELECT MAX(ISNULL(CAST(Documento AS INT), 0)) + 1 FROM ERP.Transformacion WHERE IdEmpresa = @IdEmpresa);

			UPDATE [ERP].[Transformacion] SET
			[IdTransformacionEstado] = (SELECT TOP 1 ID FROM Maestro.TransformacionEstado WHERE Abreviatura = 'R'),
			[Documento] = RIGHT('00000000' + CAST(@DOCUMENTO_GENERADO AS VARCHAR(8)), 8),
			[IdValeIngreso] = @ID_VALE_INGRESO,
			[IdValeSalida] = @ID_VALE_SALIDA
			WHERE ID = @ID
		END
		ELSE
		BEGIN
			EXEC [ERP].[Usp_Upd_Vale] @ID_VALE_INGRESO, @DataResult OUT, @XMLValeIngreso;
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
	ELSE
	BEGIN
		SELECT -1;
	END
	
END
