CREATE proc [ERP].[Usp_Ins_CajaChica_Transferencia_MovimientoTesoreria]
@IdMovimientoTesoreria INT OUT,
@XMLCajaChica XML,
@Nombre VARCHAR(250),
@Indice INT,
@IdEmpresa INT,
@IdPeriodo INT,
@IdTipoMovimiento INT,
@IdDebeHaber INT
AS
BEGIN		
		DECLARE @IdCuenta INT = (SELECT T.N.value('IdCuenta[1]','INT') FROM @XMLCajaChica.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N) WHERE T.N.value('Indice[1]','INT') = @Indice AND T.N.value('IdTipoMovimiento[1]','INT') = @IdTipoMovimiento)
		DECLARE @Orden INT = (ISNULL((SELECT MAX(Orden) FROM ERP.MovimientoTesoreria WHERE IdCuenta = @IdCuenta	AND IdEmpresa = @IdEmpresa AND IdPeriodo = @IdPeriodo AND FlagBorrador = 0),0) + 1)
		DECLARE @IdMoneda INT = (SELECT IdMoneda FROM ERP.Cuenta WHERE ID = @IdCuenta);

		INSERT INTO ERP.MovimientoTesoreria(
											IdEmpresa
											,IdPeriodo
											,IdMoneda
											,IdCuenta
											,IdTipoMovimiento
											,IdCategoriaTipoMovimiento
											,Orden
											,Fecha
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
											,FlagCajaChica
											,FlagBorrador
											,FlagConciliado
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
			@Orden													AS Orden,
			T.N.value('FechaEmision[1]',				'DATETIME')	AS FechaEmision,
			T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,
			T.N.value('Voucher[1]',				'VARCHAR(25)')		AS Voucher,			
			@Nombre	+ ' - '+T.N.value('Nombre[1]','VARCHAR(250)')		AS Nombre,
			@Nombre	+ ' - '+T.N.value('Nombre[1]','VARCHAR(250)')		AS Observacion,
			CASE WHEN (T.N.value('IdEntidad[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdEntidad[1]',			'INT')
			END														AS IdEntidad,
			CASE WHEN (T.N.value('IdTalonario[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')
			END														AS IdTalonario,
			T.N.value('NumeroCheque[1]',			'INT')			AS NumeroCheque,
			T.N.value('Total[1]',			'DECIMAL(14,5)')		AS Total,
			CAST(1 AS BIT)											AS Flag,
			T.N.value('FlagTransferencia[1]',		'BIT')			AS FlagTransferencia,
			CAST(1 AS BIT)											AS FlagCajaChica,
			T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador,
			CAST(0 AS BIT)											AS FlagConciliado,
			DATEADD(HOUR, 3, GETDATE())								AS FechaRegistro,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro
		FROM @XMLCajaChica.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N)
		WHERE T.N.value('Indice[1]','INT') = @Indice AND T.N.value('IdTipoMovimiento[1]','INT') = @IdTipoMovimiento 
		SET @IdMovimientoTesoreria = SCOPE_IDENTITY()


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
				FROM @XMLCajaChica.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N)
				WHERE T.N.value('Indice[1]','INT') = @Indice AND T.N.value('IdDebeHaber[1]','INT') = @IdDebeHaber 

END
