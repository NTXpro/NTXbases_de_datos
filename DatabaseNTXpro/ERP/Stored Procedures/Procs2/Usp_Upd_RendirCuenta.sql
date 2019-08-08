CREATE PROC [ERP].[Usp_Upd_RendirCuenta]
@IdRendirCuenta	 INT,
@XMLRendirCuenta	 XML
AS
BEGIN
SET QUERY_GOVERNOR_COST_LIMIT 56000
		SET NOCOUNT ON;
		-----============= SE MODIFICA LA CABECERA DE CAJA CHICA =============-----
		DECLARE @Orden INT = 0;
		DECLARE @IdMovimientoTesoreria INT = (SELECT T.N.value('IdMovimientoTesoreria[1]','INT') FROM @XMLRendirCuenta.nodes('/ArchivoPlanoRendirCuenta') AS T(N)); 
		DECLARE @IdMes INT= (SELECT MONTH(T.N.value('FechaEmision[1]','DATETIME')) FROM @XMLRendirCuenta.nodes('/ArchivoPlanoRendirCuenta') AS T(N));
		DECLARE @Anio INT= (SELECT YEAR(T.N.value('FechaEmision[1]','DATETIME')) FROM @XMLRendirCuenta.nodes('/ArchivoPlanoRendirCuenta') AS T(N));
		DECLARE @IdAnio INT= (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio);
		DECLARE @IdPeriodo INT= (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @IdMes);
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLRendirCuenta.nodes('/ArchivoPlanoRendirCuenta') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLRendirCuenta.nodes('/ArchivoPlanoRendirCuenta') AS T(N));
		DECLARE @Nombre VARCHAR(250) = '';
		DECLARE @IdAsiento INT;
		
		IF @FlagBorrador = 0
		BEGIN
			SET @Orden = (ISNULL((SELECT MAX(Orden) FROM ERP.MovimientoRendirCuenta WHERE IdEmpresa = @IdEmpresa AND IdPeriodo = @IdPeriodo AND FlagBorrador = 0),0) + 1);
			UPDATE ERP.MovimientoTesoreria SET FlagRindioCuenta = CAST(1 AS BIT) WHERE ID = @IdMovimientoTesoreria;
			SET @Nombre = 'RENDIR CUENTA N° ' +  CAST(@Orden AS VARCHAR(10));
		END 

		UPDATE ERP.MovimientoRendirCuenta 
		SET	Orden = @Orden,
			FlagBorrador = @FlagBorrador,
			FechaEmision = T.N.value('FechaEmision[1]','DATETIME'),
			Total = T.N.value('Total[1]','DECIMAL(14,5)'),
			TotalGastado = T.N.value('TotalGastado[1]','DECIMAL(14,5)'),
			FechaModificado = DATEADD(HOUR, 3, GETDATE()),
			UsuarioModifico = T.N.value('UsuarioModifico[1]','VARCHAR(250)')
		FROM @XMLRendirCuenta.nodes('/ArchivoPlanoRendirCuenta')	AS T(N)
		WHERE ID = @IdRendirCuenta


		-----============= SE MOFICA LAS TRANSFERENCIAS =============-----
		IF @FlagBorrador = 0
		BEGIN		
			DECLARE @TablaMovimientoTesoreriaTransferencia TABLE (Indice INT,ID INT,IdMovientoTesoreria INT,Total DECIMAL(14,5),TotalTransferencia DECIMAL(14,5))
			INSERT INTO @TablaMovimientoTesoreriaTransferencia
			SELECT ROW_NUMBER() OVER(ORDER BY T.N.value('ID[1]','INT') ASC),T.N.value('ID[1]','INT'),T.N.value('IdMovientoTesoreria[1]','INT'),
			T.N.value('Total[1]','DECIMAL(14,5)'),T.N.value('TotalTransferencia[1]','DECIMAL(14,5)')
			FROM @XMLRendirCuenta.nodes('/ListaArchivoPlanoRendirCuentaDetalleEdit/ArchivoPlanoRendirCuentaDetalle') T(N)
		
			DECLARE @i INT = 1;
			DECLARE @TOTAL_ITEMS INT;
			SET @TOTAL_ITEMS = (SELECT COUNT(Indice) FROM @TablaMovimientoTesoreriaTransferencia)

			WHILE @i <= @TOTAL_ITEMS
			BEGIN
				SET @IdMovimientoTesoreria = (SELECT IdMovientoTesoreria FROM @TablaMovimientoTesoreriaTransferencia WHERE INDICE = @i)
				DECLARE @ID INT = (SELECT ID FROM @TablaMovimientoTesoreriaTransferencia WHERE INDICE = @i)
				DECLARE @Total DECIMAL(14,5) = (SELECT Total FROM @TablaMovimientoTesoreriaTransferencia WHERE INDICE = @i)
				DECLARE @TotalTransferencia DECIMAL(14,5) = (SELECT TotalTransferencia FROM @TablaMovimientoTesoreriaTransferencia WHERE INDICE = @i)
			
				UPDATE ERP.MovimientoRendirCuentaDetalle SET Total = @Total
				WHERE ID = @ID;

				UPDATE ERP.MovimientoTesoreria SET Total = @TotalTransferencia
				WHERE ID = @IdMovimientoTesoreria
			
				UPDATE ERP.MovimientoTesoreriaDetalle SET Total = @TotalTransferencia
				WHERE IdMovimientoTesoreria =@IdMovimientoTesoreria

				SET @i = @i + 1;
			END

			---------HABILITAR COBROS
			UPDATE ERP.CuentaPagar SET FlagCancelo = 0
			WHERE ID IN (SELECT IdCuentaPagar FROM ERP.MovimientoRendirCuentaDetalle WHERE ID = @IdRendirCuenta)

			-----============= CUANDO SE ELIMINA UNA TRANSFERENCIA SE ANULAN LOS MOVIMIENTOS Y SE ELIMINA EL REGISTRO =============-----

			---ANULAR MOVIMIENTOS
			UPDATE ERP.MovimientoTesoreria SET Flag = 0
			WHERE ID IN (SELECT T.N.value('IdMovientoTesoreria[1]','INT')
						  FROM @XMLRendirCuenta.nodes('/ListaArchivoPlanoRendirCuentaDetalleEliminados/ArchivoPlanoRendirCuentaDetalle') AS T(N))
		END
		-----============= INSERTAR DETALLE CAJA CHICA =============-----
		----SE ELIMINAN LOS DETALLES DE CAJA CHICA QUE NO SEAN TRANSFERENCIA(SE VOLVERA A GENERAR)
		DELETE FROM [ERP].[MovimientoRendirCuentaDetalle] 
		WHERE IdMovimientoRendirCuenta = @IdRendirCuenta

		INSERT INTO [ERP].[MovimientoRendirCuentaDetalle](
										IdMovimientoRendirCuenta
										,IdMovimientoTesoreria
										,Orden
										,IdCuenta
										,IdPlanCuenta
										,IdProyecto
										,IdEntidad
										,IdCuentaPagar
										,Nombre
										,IdTipoComprobante
										,Serie
										,Documento
										,Total
										,IdDebeHaber
										,CodigoAuxiliar
										,FlagTransferencia
										,Operacion)
		SELECT
				@IdRendirCuenta												AS IdMovimientoCajaChica,
				CASE WHEN (T.N.value('IdMovimientoTesoreria[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdMovimientoTesoreria[1]',			'INT')
				END															AS IdMovimientoTesoreria,
				T.N.value('Orden[1]'					,'INT')				AS Orden,
				CASE WHEN (T.N.value('IdCuenta[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdCuenta[1]',			'INT')
				END															AS IdCuenta,
				CASE WHEN (T.N.value('IdPlanCuenta[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdPlanCuenta[1]',			'INT')
				END															AS IdPlanCuenta,
				CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdProyecto[1]',			'INT')
				END															AS IdProyecto,
				CASE WHEN (T.N.value('IdEntidad[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdEntidad[1]',			'INT')
				END															AS IdEntidad,
				CASE WHEN (T.N.value('IdCuentaPagar[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdCuentaPagar[1]',			'INT')
				END															AS IdCuentaPagar,
				T.N.value('Nombre[1]'		,'VARCHAR(250)')				AS Nombre,
				CASE WHEN (T.N.value('IdTipoComprobante[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdTipoComprobante[1]',			'INT')
				END															AS IdTipoComprobante,
				T.N.value('Serie[1]'		,'VARCHAR(4)')					AS Serie,
				T.N.value('Documento[1]'	,'VARCHAR(20)')					AS Documento,
				T.N.value('Total[1]',			'DECIMAL(14,5)')			AS Total,
				CASE WHEN (T.N.value('IdDebeHaber[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdDebeHaber[1]',			'INT')
				END															AS IdDebeHaber,
				T.N.value('CodigoAuxiliar[1]'	,'VARCHAR(50)')				AS CodigoAuxiliar,
				T.N.value('FlagTransferencia[1]','BIT')						AS FlagTransferencia,
				T.N.value('Operacion[1]','CHAR(1)')							AS Operacion
				FROM @XMLRendirCuenta.nodes('/ListaArchivoPlanoRendirCuentaDetalle/ArchivoPlanoRendirCuentaDetalle') AS T(N)
		
		IF @FlagBorrador = 0
		BEGIN	
			SET @IdMovimientoTesoreria = ISNULL((SELECT IdMovimientoTesoreriaGenerado FROM ERP.MovimientoRendirCuenta WHERE ID = @IdRendirCuenta), 0)
			IF @IdMovimientoTesoreria = 0 
			BEGIN
				EXEC ERP.Usp_Ins_CajaChica_MovimientoTesoreria @IdMovimientoTesoreria OUT, @XMLRendirCuenta, @Nombre, @IdEmpresa, @IdPeriodo
				UPDATE ERP.MovimientoRendirCuenta SET IdMovimientoTesoreriaGenerado = @IdMovimientoTesoreria WHERE ID = @IdRendirCuenta
				SET @IdAsiento = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreria);
				UPDATE ERP.Asiento SET Nombre = @Nombre + ' - ' + Nombre WHERE ID = @IdAsiento
			END
			ELSE
			BEGIN
				EXEC [ERP].[Usp_Upd_CajaChica_MovimientoTesoreria] @IdMovimientoTesoreria,@XMLRendirCuenta
			END
		END


		

		SET NOCOUNT OFF;
END