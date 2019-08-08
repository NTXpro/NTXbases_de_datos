
CREATE PROC [ERP].[Usp_Ins_RendirCuenta]
@IdRendirCuenta	 INT OUTPUT,
@XMLRendirCuenta	 XML
AS
BEGIN
SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

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


		INSERT INTO ERP.MovimientoRendirCuenta(IdMovimientoTesoreria
											  ,Orden
											  ,IdEmpresa
											  ,IdPeriodo
											  ,Total
											  ,ToTalGastado
											  ,FechaEmision
											  ,TipoCambio
											  ,FechaRegistro
											  ,UsuarioRegistro
											  ,Flag
											  ,FlagBorrador
											)
		SELECT
			T.N.value('IdMovimientoTesoreria[1]','INT')				AS IdMovimientoTesoreria,
			@Orden,
			T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
			@IdPeriodo,									
			T.N.value('Total[1]',		'DECIMAL(14,5)')			AS Total,
			T.N.value('TotalGastado[1]',		'DECIMAL(14,5)')	AS TotalGastado,
			T.N.value('FechaEmision[1]',		'DATETIME')			AS FechaEmision,
			T.N.value('TipoCambio[1]',		'DECIMAL(14,5)')		AS TipoCambio,
			DATEADD(HOUR, 3, GETDATE()),
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')	    AS UsuarioRegistro,
			CAST(1 AS BIT),
			T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador
		FROM @XMLRendirCuenta.nodes('/ArchivoPlanoRendirCuenta')	AS T(N)
		SET @IdRendirCuenta = SCOPE_IDENTITY()

		INSERT INTO [ERP].[MovimientoRendirCuentaDetalle](
										IdMovimientoRendirCuenta
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

		-----SE REGISTRA EL MOVIMIENTO DE CAJA CHICA Y SE GENERA LOS ASIENTOS 
		IF @FlagBorrador = 0
		BEGIN
			EXEC ERP.Usp_Ins_CajaChica_MovimientoTesoreria @IdMovimientoTesoreria OUT, @XMLRendirCuenta, @Nombre, @IdEmpresa, @IdPeriodo

			UPDATE ERP.MovimientoRendirCuenta SET IdMovimientoTesoreriaGenerado = @IdMovimientoTesoreria WHERE ID = @IdRendirCuenta

			SET @IdAsiento = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreria);

			UPDATE ERP.Asiento SET Nombre = @Nombre + ' - ' + Nombre WHERE ID = @IdAsiento
		END

		SET NOCOUNT OFF;
END