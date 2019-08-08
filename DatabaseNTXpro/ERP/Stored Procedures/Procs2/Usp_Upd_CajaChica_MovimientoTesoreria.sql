
CREATE proc [ERP].[Usp_Upd_CajaChica_MovimientoTesoreria]
@IdMovimientoTesoreria INT,
@XMLCajaChica XML
AS
BEGIN		

	UPDATE ERP.MovimientoTesoreria
	SET  Total = T.N.value('Total[1]','DECIMAL(14,5)')
	    ,Fecha = T.N.value('FechaEmision[1]','DATETIME')
		,FechaModificado = DATEADD(HOUR, 3, GETDATE())
		,UsuarioModifico = T.N.value('UsuarioModifico[1]','VARCHAR(250)')
	FROM @XMLCajaChica.nodes('/ArchivoPlanoMovimientoTesoreria')	AS T(N)
	WHERE ID = @IdMovimientoTesoreria

	DECLARE @FlagBorrador BIT = (SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLCajaChica.nodes('/ArchivoPlanoMovimientoTesoreria') AS T(N));
	DELETE FROM [ERP].[MovimientoTesoreriaDetalleCuentaPagar] WHERE IdMovimientoTesoreriaDetalle IN  (SELECT MTD.ID FROM ERP.MovimientoTesoreriaDetalle MTD  WHERE MTD.IdMovimientoTesoreria = @IdMovimientoTesoreria)
	DELETE FROM [ERP].[MovimientoTesoreriaDetalleCuentaCobrar]WHERE IdMovimientoTesoreriaDetalle IN  (SELECT MTD.ID FROM ERP.MovimientoTesoreriaDetalle MTD  WHERE MTD.IdMovimientoTesoreria = @IdMovimientoTesoreria)
	DELETE FROM [ERP].[MovimientoTesoreriaDetalle] WHERE IdMovimientoTesoreria = @IdMovimientoTesoreria
	
	
	------==========================  INSERT DETALLE MOVIMIENTOTESORERIADETALLE =======================================------
	DECLARE @IdMovimientoTesoreriaDetalle INT = 0;
	DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(T.N.value('Orden[1]','INT')) FROM @XMLCajaChica.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N))
	DECLARE @Operacion CHAR(1) = '';
	DECLARE @IdCuentaCobrar INT = 0;
	DECLARE @IdCuentaPagar INT = 0;

	DECLARE @i INT = 1;
	WHILE @i <= @TOTAL_ITEMS
	BEGIN
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
			WHERE T.N.value('Orden[1]','INT') = @i 

			SET @IdMovimientoTesoreriaDetalle = SCOPE_IDENTITY()

			------==========================  INSERT DETALLE MOVIMIENTOTESORERIADETALLE - CUENTAPAGAR - CUENTACOBRAR =======================================------

			SET @Operacion = (SELECT T.N.value('PagarCobrar[1]','CHAR(1)')
			FROM @XMLCajaChica.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N)
			WHERE T.N.value('Orden[1]','INT') = @i)

			IF @Operacion = 'P' --DEBE
				BEGIN
					SET @IdCuentaPagar = (SELECT T.N.value('IdCuentacobrarPagar[1]','INT')
					FROM @XMLCajaChica.nodes('/ListaArchivoPlanoMovimientoTesoreriaDetalle/ArchivoPlanoMovimientoTesoreriaDetalle') AS T(N)
					WHERE T.N.value('Orden[1]','INT') = @i);

					INSERT INTO ERP.MovimientoTesoreriaDetalleCuentaPagar(IdCuentaPagar, IdMovimientoTesoreriaDetalle)
					VALUES(@IdCuentaPagar,@IdMovimientoTesoreriaDetalle)

					UPDATE ERP.CuentaPagar SET FlagCancelo = 0 WHERE ID = @IdCuentaPagar

					UPDATE ERP.CuentaPagar SET FlagCancelo = 1 
					WHERE ID = @IdCuentaPagar AND (CASE WHEN IdMoneda = 1 THEN
														(SELECT [ERP].[SaldoTotalCuentaPagarDeSoles](ID))
													ELSE
														(SELECT [ERP].[SaldoTotalCuentaPagarDeDolares](ID))
													END)  = 0;
				END
		SET @i = @i + 1

	END

	------==========================  INSERT ASIENTOS CONTABLES =======================================------

	IF @FlagBorrador = 0
	BEGIN
		DECLARE @IdAsiento INT = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreria)
		IF @IdAsiento IS NULL
		BEGIN
			EXEC [ERP].[Usp_Ins_AsientoContable_Tesoreria] @IdAsiento OUT, @IdMovimientoTesoreria, 6 /*ASIENTO TESORERIA*/, 5/*TESORERIA*/
		END
		ELSE
		BEGIN
			EXEC [ERP].[Usp_Upd_AsientoContable_Tesoreria] @IdAsiento, @IdMovimientoTesoreria, 6 /*ASIENTO TESORERIA*/, 5/*TESORERIA*/
		END
		UPDATE ERP.MovimientoTesoreria SET IdAsiento = @IdAsiento WHERE ID = @IdMovimientoTesoreria
	END

END
