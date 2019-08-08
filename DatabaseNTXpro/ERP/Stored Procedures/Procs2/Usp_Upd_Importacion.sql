CREATE PROCEDURE [ERP].[Usp_Upd_Importacion]
@ID INT,
@IdEmpresa INT,
@IdAlmacen INT,
@IdMoneda INT,
@IdProyecto INT,
@Observacion VARCHAR(250),
@Fecha DATETIME,
@FechaVale DATETIME,
@UsuarioModifico VARCHAR(250),
@FechaModificado DATETIME,
----------
@XMLListaImportacionReferencia XML,
@XMLListaImportacionProductoDetalle XML,
@XMLListaImportacionServicioDetalle XML,
@XMLValeTransaccion XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000

	DECLARE @OPCIONAL VARCHAR(MAX) = '';
	DECLARE @ID_VALE INT = (SELECT IdVale FROM ERP.Importacion WHERE ID = @ID);
	DECLARE @DOCUMENTO VARCHAR(10) = (SELECT Documento FROM ERP.Importacion  WHERE ID = @ID);
	DECLARE @CONDICIO_FECHA_VALE VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro WHERE Abreviatura = 'LRVCFP' AND IdEmpresa = @IdEmpresa)

	UPDATE [ERP].[Importacion] SET
	[IdEmpresa] = @IdEmpresa,
	[IdAlmacen] = @IdAlmacen,
	[IdMoneda] = @IdMoneda,
	[IdProyecto] = (CASE @IdProyecto WHEN 0 THEN NULL ELSE @IdProyecto END),
	[Observacion] = @Observacion,
	[Fecha] = @Fecha,
	[UsuarioModifico] = @UsuarioModifico,
	[FechaModificado] = @FechaModificado,
	[FlagBorrador] = 0,
	[Flag] = 1
	WHERE ID = @ID

	IF(@CONDICIO_FECHA_VALE = '1')
	BEGIN
		UPDATE [ERP].[Importacion] SET [FechaVale] = @FechaVale WHERE ID = @ID;
	END

	IF (@DOCUMENTO IS NULL)
	BEGIN
		EXEC [ERP].[Usp_Ins_Vale] @ID_VALE OUT, @OPCIONAL OUT, @XMLValeTransaccion;

		DECLARE @DOCUMENTO_GENERADO INT = (SELECT MAX(ISNULL(CAST(Documento AS INT), 0)) + 1 FROM ERP.Importacion WHERE IdEmpresa = @IdEmpresa);

		UPDATE [ERP].[Importacion] SET
		[IdImportacionEstado] = (SELECT TOP 1 ID FROM Maestro.ImportacionEstado WHERE Abreviatura = 'R'),
		[Documento] = RIGHT('00000000' + CAST(@DOCUMENTO_GENERADO AS VARCHAR(8)), 8),
		[IdVale] = @ID_VALE
		WHERE ID = @ID
	END
	ELSE
	BEGIN
		EXEC [ERP].[Usp_Upd_Vale] @ID_VALE, @OPCIONAL OUT, @XMLValeTransaccion;
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
			   ([Item]
			   ,[IdImportacion]
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
			T.N.value('Item[1]', 'INT'),
			@ID,
			(CASE T.N.value('IdOrdenCompra[1]', 'INT') WHEN 0 THEN NULL ELSE T.N.value('IdOrdenCompra[1]', 'INT') END),
			T.N.value('IdProducto[1]', 'INT'),
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
			T.N.value('IdImportacionServicio[1]', 'INT'),
			T.N.value('TipoCambio[1]', 'DECIMAL(18,5)'),
			T.N.value('Soles[1]', 'DECIMAL(18,5)'),
			T.N.value('Dolares[1]', 'DECIMAL(18,5)')
		FROM 
		@XMLListaImportacionServicioDetalle.nodes('/ImportacionServicioDetalle') AS T(N)

	END

	SELECT @ID;
	
END