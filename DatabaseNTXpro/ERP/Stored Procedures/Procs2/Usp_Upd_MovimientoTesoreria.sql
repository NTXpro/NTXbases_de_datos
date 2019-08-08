CREATE PROC [ERP].[Usp_Upd_MovimientoTesoreria]
@IdMovimientoTesoreria INT,
@XMLMovimientoTesoreria	 XML
AS
BEGIN	
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	SET NOCOUNT ON;
	DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreria)
	DECLARE @Orden INT = (SELECT Orden FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreria)
	DECLARE @IdMes INT= (SELECT MONTH(T.N.value('FechaEmision[1]','DATETIME')) FROM @XMLMovimientoTesoreria.nodes('/ArchivoPlanoMovimientoTesoreria')	AS T(N))
	DECLARE @Anio INT= (SELECT YEAR(T.N.value('FechaEmision[1]','DATETIME')) FROM @XMLMovimientoTesoreria.nodes('/ArchivoPlanoMovimientoTesoreria')	AS T(N))
	DECLARE @IdAnio INT= (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio)
	DECLARE @IdPeriodo INT= (SELECT ID FROM ERP.Periodo WHERE IdMes = @IdMes AND IdAnio = @IdAnio)
	DECLARE @FlagBorrador BIT = (SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLMovimientoTesoreria.nodes('/ArchivoPlanoMovimientoTesoreria') AS T(N));
	DECLARE @IdCuenta INT = (SELECT T.N.value('IdCuenta[1]','INT') FROM @XMLMovimientoTesoreria.nodes('/ArchivoPlanoMovimientoTesoreria') AS T(N));
	DECLARE @IdMoneda INT = (SELECT IdMoneda FROM ERP.Cuenta WHERE ID = @IdCuenta);	

	IF @FlagBorrador = 0 AND (@Orden IS NULL OR @Orden = 0)
	BEGIN
		SET @Orden = (ISNULL((SELECT MAX(Orden) FROM ERP.MovimientoTesoreria WHERE IdEmpresa = @IdEmpresa AND IdPeriodo = @IdPeriodo AND IdCuenta = @IdCuenta AND FlagBorrador = 0),0) + 1)
	END 
		
	IF @FlagBorrador = 0
	BEGIN
		UPDATE ERP.MovimientoTesoreria
		SET IdCategoriaTipoMovimiento = CASE WHEN (T.N.value('IdCategoriaTipoMovimiento[1]','INT') = 0) THEN
											NULL
										ELSE 
											T.N.value('IdCategoriaTipoMovimiento[1]',			'INT')
										END
			,Orden = @Orden
			,Voucher = T.N.value('Voucher[1]','VARCHAR(25)')
			,Nombre = T.N.value('Nombre[1]','VARCHAR(250)')
			,Observacion = T.N.value('Observacion[1]','VARCHAR(250)')
			,FechaVencimiento = T.N.value('FechaVencimiento[1]','DATETIME')
			,IdEntidad = CASE WHEN (T.N.value('IdEntidad[1]','INT') = 0) THEN
							NULL
						ELSE 
							T.N.value('IdEntidad[1]',			'INT')
						END
			,IdTalonario = CASE WHEN (T.N.value('IdTalonario[1]','INT') = 0) THEN
								NULL
							ELSE 
								T.N.value('IdTalonario[1]',			'INT')
							END
			,NumeroCheque = T.N.value('NumeroCheque[1]','INT')
			,Total = T.N.value('Total[1]','DECIMAL(14,5)')
			,TipoCambio = T.N.value('TipoCambio[1]','DECIMAL(14,5)')
			,FlagBorrador = T.N.value('FlagBorrador[1]','BIT')
			,FlagCheque = T.N.value('FlagCheque[1]','BIT')
			,FlagChequeDiferido = T.N.value('FlagChequeDiferido[1]','BIT')
			,FechaModificado = DATEADD(HOUR, 3, GETDATE())
			,UsuarioModifico = T.N.value('UsuarioModifico[1]','VARCHAR(250)')
			,IdCuenta = @IdCuenta
		FROM @XMLMovimientoTesoreria.nodes('/ArchivoPlanoMovimientoTesoreria')	AS T(N)
		WHERE ID = @IdMovimientoTesoreria

		UPDATE ERP.CuentaPagar 
		SET FlagCancelo = 0
		WHERE ID IN (SELECT IdCuentaPagar 
						FROM ERP.MovimientoTesoreriaDetalleCuentaPagar 
						WHERE IdMovimientoTesoreriaDetalle IN (SELECT ID 
																FROM ERP.MovimientoTesoreriaDetalle 
																WHERE IdMovimientoTesoreria = @IdMovimientoTesoreria))

		UPDATE ERP.CuentaCobrar 
		SET FlagCancelo = 0
		WHERE ID IN (SELECT IdCuentaCobrar 
					FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar 
					WHERE IdMovimientoTesoreriaDetalle IN (SELECT ID 
															FROM ERP.MovimientoTesoreriaDetalle 
															WHERE IdMovimientoTesoreria = @IdMovimientoTesoreria))
	END
	ELSE
	BEGIN
		UPDATE ERP.MovimientoTesoreria
		SET  IdPeriodo = @IdPeriodo
			,IdMoneda = @IdMoneda
			,IdCuenta  = 	CASE WHEN (T.N.value('IdCuenta[1]','INT') = 0) THEN
								NULL
							ELSE 
								T.N.value('IdCuenta[1]','INT')
							END	
			,IdTipoMovimiento = CASE WHEN (T.N.value('IdTipoMovimiento[1]','INT') = 0) THEN
									NULL
								ELSE 
									T.N.value('IdTipoMovimiento[1]',			'INT')
								END
			,IdCategoriaTipoMovimiento = CASE WHEN (T.N.value('IdCategoriaTipoMovimiento[1]','INT') = 0) THEN
											NULL
										ELSE 
											T.N.value('IdCategoriaTipoMovimiento[1]',			'INT')
										END
			,Fecha = T.N.value('FechaEmision[1]','DATETIME')
			,Orden = @Orden
			,TipoCambio = T.N.value('TipoCambio[1]','DECIMAL(14,5)')
			,FechaVencimiento = T.N.value('FechaVencimiento[1]','DATETIME')
			,Voucher = T.N.value('Voucher[1]','VARCHAR(25)')
			,Nombre = T.N.value('Nombre[1]','VARCHAR(250)')
			,Observacion = T.N.value('Observacion[1]','VARCHAR(250)')
			,IdEntidad = CASE WHEN (T.N.value('IdEntidad[1]','INT') = 0) THEN
							NULL
						ELSE 
							T.N.value('IdEntidad[1]',			'INT')
						END
			,IdTalonario = CASE WHEN (T.N.value('IdTalonario[1]','INT') = 0) THEN
								NULL
							ELSE 
								T.N.value('IdTalonario[1]',			'INT')
							END
			,NumeroCheque = T.N.value('NumeroCheque[1]','INT')
			,Total = T.N.value('Total[1]','DECIMAL(14,5)')
			,FlagBorrador = T.N.value('FlagBorrador[1]','BIT')
			,FechaModificado = DATEADD(HOUR, 3, GETDATE())
			,UsuarioModifico = T.N.value('UsuarioModifico[1]','VARCHAR(250)')
		FROM @XMLMovimientoTesoreria.nodes('/ArchivoPlanoMovimientoTesoreria')	AS T(N)
		WHERE ID = @IdMovimientoTesoreria
	END	
	
	IF @FlagBorrador = 0
	BEGIN
		DELETE FROM [ERP].[MovimientoTesoreriaDetalleCuentaPagar]
		WHERE IdMovimientoTesoreriaDetalle IN (SELECT MTD.ID
											FROM ERP.MovimientoTesoreriaDetalle MTD 
											WHERE MTD.IdMovimientoTesoreria = @IdMovimientoTesoreria)

		DELETE FROM [ERP].[MovimientoTesoreriaDetalleCuentaCobrar] 
		WHERE IdMovimientoTesoreriaDetalle IN (SELECT MTD.ID 
											FROM ERP.MovimientoTesoreriaDetalle MTD 
											WHERE MTD.IdMovimientoTesoreria = @IdMovimientoTesoreria)

		DELETE FROM [ERP].[MovimientoTesoreriaDetalle] 
		WHERE IdMovimientoTesoreria = @IdMovimientoTesoreria
		
		------==========================  INSERT DETALLE MOVIMIENTOTESORERIADETALLE =======================================------
		DECLARE @IdMovimientoTesoreriaDetalle INT = 0;
		DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(T.N.value('Orden[1]','INT')) FROM @XMLMovimientoTesoreria.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N))
		DECLARE @Operacion CHAR(1) = '';
		DECLARE @IdCuentaCobrar INT = 0;
		DECLARE @IdCuentaPagar INT = 0;			
		
		INSERT INTO [ERP].[MovimientoTesoreriaDetalle]
			(
			IdMovimientoTesoreria
			,Orden
			,IdPlanCuenta
			,IdProyecto
			,IdEntidad
			,Nombre
			,IdTipoComprobante
			,Serie
			,Documento
			,Total
			,IdDebeHaber
			,CodigoAuxiliar
			,PagarCobrar
			)
		SELECT
		@IdMovimientoTesoreria										AS IdMovimientoTesoreria,
		T.N.value('Orden[1]'					,'INT')				AS Orden,
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
		T.N.value('CodigoAuxiliar[1]'	,'VARCHAR(50)')					AS CodigoAuxiliar,
		T.N.value('PagarCobrar[1]'	,'CHAR(1)')					AS PagarCobrar
		FROM @XMLMovimientoTesoreria.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N)
		
		DECLARE @i INT = 1;
		WHILE @i <= @TOTAL_ITEMS
		BEGIN
				SELECT @IdMovimientoTesoreriaDetalle  = ID
				FROM [ERP].[MovimientoTesoreriaDetalle]
				WHERE Orden = @i
				AND @IdMovimientoTesoreria = IdMovimientoTesoreria

				IF (SELECT T.N.value('IdCuentacobrarPagar[1]','INT')
					FROM @XMLMovimientoTesoreria.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N)
					WHERE T.N.value('Orden[1]','INT') = @i) > 0
				BEGIN
					------==========================  INSERT DETALLE MOVIMIENTOTESORERIADETALLE - CUENTAPAGAR - CUENTACOBRAR =======================================------

					SET @Operacion = (SELECT T.N.value('PagarCobrar[1]','CHAR(1)')
					FROM @XMLMovimientoTesoreria.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N)
					WHERE T.N.value('Orden[1]','INT') = @i)

					IF @Operacion = 'P' --DEBE
						BEGIN

							SET @IdCuentaPagar = (SELECT T.N.value('IdCuentacobrarPagar[1]','INT')
							FROM @XMLMovimientoTesoreria.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N)
							WHERE T.N.value('Orden[1]','INT') = @i);

							INSERT INTO ERP.MovimientoTesoreriaDetalleCuentaPagar(IdCuentaPagar, IdMovimientoTesoreriaDetalle)
							VALUES(@IdCuentaPagar, @IdMovimientoTesoreriaDetalle)

							UPDATE ERP.CuentaPagar
							SET FlagCancelo = 0
							WHERE ID = @IdCuentaPagar

							UPDATE ERP.CuentaPagar
							SET FlagCancelo = 1
							WHERE ID = @IdCuentaPagar AND (CASE WHEN IdMoneda = 1 THEN
																(SELECT [ERP].[SaldoTotalCuentaPagarDeSoles](ID))
															ELSE
																(SELECT [ERP].[SaldoTotalCuentaPagarDeDolares](ID))
															END) = 0;
						END
					ELSE IF  @Operacion = 'C'
						BEGIN
					
							SET @IdCuentaCobrar = (SELECT T.N.value('IdCuentacobrarPagar[1]','INT')
							FROM @XMLMovimientoTesoreria.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N)
							WHERE T.N.value('Orden[1]','INT') = @i)

							INSERT INTO ERP.MovimientoTesoreriaDetalleCuentaCobrar(IdCuentaCobrar, IdMovimientoTesoreriaDetalle)
							VALUES(@IdCuentaCobrar, @IdMovimientoTesoreriaDetalle)

							UPDATE ERP.CuentaCobrar 
							SET FlagCancelo = 0 
							WHERE ID = @IdCuentaCobrar
					
							UPDATE ERP.CuentaCobrar 
							SET FlagCancelo = 1
							WHERE ID = @IdCuentaCobrar 
							AND (CASE WHEN IdMoneda = 1 THEN
										(SELECT [ERP].[SaldoTotalCuentaCobrarDeSoles](ID))
									ELSE
										(SELECT [ERP].[SaldoTotalCuentaCobrarDeDolares](ID))
								END) = 0;
						END
				END

				

			SET @i = @i + 1
		END

		
	END
	
	------==========================  INSERT ASIENTOS CONTABLES =======================================------	
	IF @FlagBorrador = 0
	BEGIN
		DECLARE @IdAsiento INT = (SELECT IdAsiento 
									FROM ERP.MovimientoTesoreria 
									WHERE ID = @IdMovimientoTesoreria)
		IF @IdAsiento IS NULL
		BEGIN			
			EXEC [ERP].[Usp_Ins_AsientoContable_Tesoreria] @IdAsiento OUT, @IdMovimientoTesoreria, 6 /*ASIENTO TESORERIA*/, 5/*TESORERIA*/
		END
		ELSE
		BEGIN			
			EXEC [ERP].[Usp_Upd_AsientoContable_Tesoreria] @IdAsiento, @IdMovimientoTesoreria, 6 /*ASIENTO TESORERIA*/, 5/*TESORERIA*/
		END		
		UPDATE ERP.MovimientoTesoreria 
		SET IdAsiento = @IdAsiento 
		WHERE ID = @IdMovimientoTesoreria
	END	
	SET NOCOUNT OFF;
END