

CREATE PROCEDURE [ERP].[Usp_Ins_MovimientoTransferenciaMasivaCuenta]
@IdTransferencia INT OUTPUT,
@XMLMovimientoTransferencia XML,
@XMLMovimientoTesoreriaEmisor XML,
@XMLMovimientoTesoreriaReceptor XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		--SET NOCOUNT ON;
		DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
		DECLARE @IdMovimientoTesoreriaEmisor INT;
		DECLARE @IdMovimientoTesoreriaReceptor INT;
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLMovimientoTransferencia.nodes('/ArchivoPlanoTransferencia') AS T(N));
		DECLARE @FlagBorrador BIT= (SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLMovimientoTransferencia.nodes('/ArchivoPlanoTransferencia')	AS T(N))
		DECLARE @IdMes INT= (SELECT MONTH(T.N.value('FechaEmisor[1]','DATETIME')) FROM @XMLMovimientoTransferencia.nodes('/ArchivoPlanoTransferencia') AS T(N))
		DECLARE @Anio INT= (SELECT YEAR(T.N.value('FechaEmisor[1]','DATETIME')) FROM @XMLMovimientoTransferencia.nodes('/ArchivoPlanoTransferencia')	AS T(N))
		DECLARE @IdAnio INT= (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio)
		DECLARE @IdPeriodo INT= (SELECT ID FROM ERP.Periodo WHERE IdMes = @IdMes AND IdAnio = @IdAnio)
		---------=========== SE REGISTRAR EL MOVIMIENTO EMISOR ===========---------
		IF @FlagBorrador = 0
		BEGIN
			EXEC ERP.Usp_Ins_MovimientoTesoreria @IdMovimientoTesoreriaEmisor OUT, @XMLMovimientoTesoreriaEmisor
		END

		---------=========== SE REGISTRAR LA TRANSFERENCIA ===========---------
		INSERT INTO ERP.MovimientoTransferenciaMasivaCuenta(IdEmpresa
														   ,IdCuentaEmisor
														   ,IdCategoriaTipoMovimientoEmisor
														   ,IdMovimientoTesoreriaEmisor
														   ,IdTalonarioEmisor
														   ,NumeroChequeEmisor
														   ,FechaEmisor
														   ,FechaVencimientoEmisor
														   ,TipoCambioEmisor
														   ,MontoEmisor
														   ,AjusteEmisor
														   ,DocumentoEmisor
														   ,ObservacionEmisor
														   ,OrdenDeEmisor
														   ,FlagChequeDiferido
														   ,FlagCheque
														   ,FechaRegistro
														   ,UsuarioRegistro
														   ,FechaModificado
														   ,UsuarioModifico
														   ,Flag
														   ,FlagBorrador
														   )
		SELECT
			T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
			CASE WHEN (T.N.value('IdCuentaEmisor[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdCuentaEmisor[1]','INT')
			END														AS IdCuentaEmisor,	
			CASE WHEN (T.N.value('IdCategoriaTipoMovimientoEmisor[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdCategoriaTipoMovimientoEmisor[1]',			'INT')
			END														AS IdCategoriaTipoMovimientoEmisor,	
			@IdMovimientoTesoreriaEmisor,
			CASE WHEN (T.N.value('IdTalonarioEmisor[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdTalonarioEmisor[1]',			'INT')
			END														AS IdTalonarioEmisor,	
			T.N.value('NumeroChequeEmisor[1]',				'INT')	AS NumeroChequeEmisor,
			T.N.value('FechaEmisor[1]',				'DATETIME')	AS FechaEmision,
			T.N.value('FechaVencimientoEmisor[1]',				'DATETIME')	AS FechaVencimientoEmisor,
			T.N.value('TipoCambioEmisor[1]',				'DECIMAL(14,5)')	AS TipoCambioEmisor,
			T.N.value('MontoEmisor[1]',				'DECIMAL(14,5)')	AS MontoEmisor,
			T.N.value('AjusteEmisor[1]',				'DECIMAL(14,5)')	AS AjusteEmisor,
			T.N.value('DocumentoEmisor[1]',				'VARCHAR(25)')	AS DocumentoEmisor,
			T.N.value('ObservacionEmisor[1]',				'VARCHAR(250)')	AS ObservacionEmisor,
			T.N.value('OrdenDeEmisor[1]',				'VARCHAR(250)')	AS OrdenDeEmisor,
			T.N.value('FlagChequeDiferido[1]',				'BIT')	AS FlagChequeDiferido,
			T.N.value('FlagCheque[1]',				'BIT')		AS FlagCheque,
			@FechaActual,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
			@FechaActual,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioModifico,
			CAST(1 AS BIT)                                      AS Flag,		
			T.N.value('FlagBorrador[1]',				'BIT')	AS FlagBorrador
		FROM @XMLMovimientoTransferencia.nodes('/ArchivoPlanoTransferencia')	AS T(N)
		SET @IdTransferencia = SCOPE_IDENTITY()
		
		---------=========== SE REGISTRAR EL DETALLE DE LA TRANSFERENCIA===========---------
		INSERT INTO [ERP].[MovimientoTransferenciaMasivaCuentaDetalle]
					(
					 IdMovimientoTransferenciaMasivaCuenta
					,IdCuentaReceptor
					,IdCategoriaTipoMovimientoReceptor
					,IdProyecto
					,IdDebeHaber
					,MontoReceptor
					,Orden
					)
				SELECT
				@IdTransferencia										AS IdMovimientoTransferenciaMasivaCuenta,
				CASE WHEN (T.N.value('IdCuentaReceptor[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdCuentaReceptor[1]',			'INT')
				END															AS IdCuentaReceptor,
				CASE WHEN (T.N.value('IdCategoriaTipoMovimientoReceptor[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdCategoriaTipoMovimientoReceptor[1]',			'INT')
				END															AS IdCategoriaTipoMovimientoReceptor,
				CASE WHEN (T.N.value('IdProyecto[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdProyecto[1]',			'INT')
				END															AS IdProyecto,
				CASE WHEN (T.N.value('IdDebeHaber[1]','INT') = 0) THEN
					NULL
				ELSE 
					T.N.value('IdDebeHaber[1]',			'INT')
				END															AS IdDebeHaber,
				T.N.value('MontoReceptor[1]',				'DECIMAL(14,5)')	AS MontoReceptor,
				T.N.value('Indice[1]',			'INT')						AS	Orden
				FROM @XMLMovimientoTransferencia.nodes('/ListaArchivoPlanoTransferenciaDetalle/ArchivoPlanoTransferenciaDetalle') AS T(N)
				
		---------=========== SE MODIFICA EL NOMBRE DEL ASIENTO EMISOR ===========---------
		IF @FlagBorrador = 0
		BEGIN
			DECLARE @IdAsiento INT =(SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreriaEmisor)

			DECLARE @NombreAsiento VARCHAR(250) = (SELECT UPPER('TRANSFERENCIA DESDE '+CE.Nombre)
													FROM ERP.MovimientoTransferenciaMasivaCuenta MTC 
													LEFT JOIN ERP.Cuenta CE ON CE.ID = MTC.IdCuentaEmisor
													WHERE MTC.IdMovimientoTesoreriaEmisor = @IdMovimientoTesoreriaEmisor)
													
			UPDATE ERP.Asiento set Nombre = @NombreAsiento WHERE ID = @IdAsiento
		END

		---------=========== SE GENERA LOS MOVIMIENTOS RECEPTORES DEL DETALLE DE TRANSFERENCIA ===========---------
		IF @FlagBorrador = 0
		BEGIN
			DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(T.N.value('Indice[1]','INT')) FROM @XMLMovimientoTesoreriaReceptor.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N))
			DECLARE @i INT = 1;
			WHILE @i <= @TOTAL_ITEMS
			BEGIN
				DECLARE @IdCuenta INT = (SELECT T.N.value('IdCuenta[1]','INT') FROM @XMLMovimientoTesoreriaReceptor.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N) WHERE T.N.value('Indice[1]','INT') = @i);
				DECLARE @IdTipoMovimiento INT = (SELECT T.N.value('IdTipoMovimiento[1]','INT') FROM @XMLMovimientoTesoreriaReceptor.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N) WHERE T.N.value('Indice[1]','INT') = @i);
				DECLARE @IdMoneda INT = (SELECT IdMoneda FROM ERP.Cuenta WHERE ID = @IdCuenta);
				DECLARE @Orden INT = (ISNULL((SELECT MAX(Orden) FROM ERP.MovimientoTesoreria WHERE IdEmpresa = @IdEmpresa AND IdPeriodo = @IdPeriodo AND IdCuenta = @IdCuenta AND FlagBorrador = 0),0) + 1)

				INSERT INTO ERP.MovimientoTesoreria(
												IdEmpresa
												,IdPeriodo
												,IdMoneda
												,IdCuenta
												,IdTipoMovimiento
												,IdCategoriaTipoMovimiento
												,Orden
												,Fecha
												,FechaVencimiento
												,TipoCambio
												,Voucher
												,Nombre
												,Observacion
												,IdEntidad
												,IdTalonario
												,NumeroCheque
												,Total
												,Flag
												,FlagTransferencia
												,FlagConciliado
												,FlagCheque
												,FlagChequeDiferido
												,FlagBorrador
												,FechaRegistro
												,UsuarioRegistro
										) 
				SELECT
					T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
					@IdPeriodo,
					@IdMoneda,
					CASE WHEN (T.N.value('IdCuenta[1]','INT') = 0) THEN
						NULL
					ELSE 
						T.N.value('IdCuenta[1]','INT')
					END														AS IdCuenta,	
					CASE WHEN (T.N.value('IdTipoMovimiento[1]','INT') = 0) THEN
						NULL
					ELSE 
						T.N.value('IdTipoMovimiento[1]',			'INT')
					END														AS IdTipoMovimiento,	
					CASE WHEN (T.N.value('IdCategoriaTipoMovimiento[1]','INT') = 0) THEN
						NULL
					ELSE 
						T.N.value('IdCategoriaTipoMovimiento[1]',			'INT')
					END														AS IdCategoriaTipoMovimiento,
					@Orden                                                  AS Orden,
					T.N.value('FechaEmision[1]',				'DATETIME')	AS FechaEmision,
					T.N.value('FechaVencimiento[1]',				'DATETIME')	AS FechaVencimiento,
					T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,
					T.N.value('Voucher[1]',				'VARCHAR(25)')		AS Voucher,			
					T.N.value('Nombre[1]',				'VARCHAR(250)')		AS Nombre,
					T.N.value('Observacion[1]',			'VARCHAR(250)')		AS Observacion,
					CASE WHEN (T.N.value('IdEntidad[1]','INT') = 0) THEN
						NULL
					ELSE 
						T.N.value('IdEntidad[1]',			'INT')
					END														AS IdEntidad,
					CASE WHEN (T.N.value('IdTalonario[1]','INT') = 0) THEN
						NULL
					ELSE 
						T.N.value('IdTalonario[1]',			'INT')
					END														AS IdTalonario,
					T.N.value('NumeroCheque[1]',			'INT')			AS NumeroCheque,
					T.N.value('Total[1]',			'DECIMAL(14,5)')		AS Total,
					CAST(1 AS BIT)											AS Flag,
					T.N.value('FlagTransferencia[1]',		'BIT')			AS FlagTransferencia,
					CAST(0 AS BIT)											AS FlagConciliado,
					T.N.value('FlagCheque[1]',		'BIT')					AS FlagCheque,
					T.N.value('FlagChequeDiferido[1]',		'BIT')			AS FlagChequeDiferido,
					T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador,
					DATEADD(HOUR, 3, GETDATE())								AS FechaRegistro,
					T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro
				FROM @XMLMovimientoTesoreriaReceptor.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N)
				WHERE T.N.value('Indice[1]','INT') = @i

				SET @IdMovimientoTesoreriaReceptor = SCOPE_IDENTITY()

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
					@IdMovimientoTesoreriaReceptor								AS IdMovimientoTesoreria,
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
					FROM @XMLMovimientoTesoreriaReceptor.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N)
					WHERE T.N.value('Indice[1]','INT') = @i

					UPDATE [ERP].[MovimientoTransferenciaMasivaCuentaDetalle] SET IdMovimientoTesoreriaReceptor = @IdMovimientoTesoreriaReceptor WHERE IdMovimientoTransferenciaMasivaCuenta = @IdTransferencia AND Orden = @i

					SET @i = @i + 1
			END
		END
END
