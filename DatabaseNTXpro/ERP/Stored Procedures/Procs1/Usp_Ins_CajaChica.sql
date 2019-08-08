
CREATE PROC [ERP].[Usp_Ins_CajaChica]
@IdCajaChica	 INT OUTPUT,
@XMLCajaChica	 XML
AS
BEGIN
SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @Orden INT = 0;
		DECLARE @IdMes INT= (SELECT MONTH(T.N.value('FechaEmision[1]','DATETIME')) FROM @XMLCajaChica.nodes('/ArchivoPlanoCajaChica') AS T(N));
		DECLARE @Anio INT= (SELECT YEAR(T.N.value('FechaEmision[1]','DATETIME')) FROM @XMLCajaChica.nodes('/ArchivoPlanoCajaChica') AS T(N));
		DECLARE @IdAnio INT= (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio);
		DECLARE @IdPeriodo INT= (SELECT ID FROM ERP.Periodo WHERE IdMes = @IdMes AND IdAnio = @IdAnio);
		DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLCajaChica.nodes('/ArchivoPlanoCajaChica') AS T(N));
		DECLARE @FlagBorrador BIT = (SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLCajaChica.nodes('/ArchivoPlanoCajaChica') AS T(N));
		DECLARE @IdCuenta INT = (SELECT T.N.value('IdCuenta[1]','INT') FROM @XMLCajaChica.nodes('/ArchivoPlanoCajaChica') AS T(N));
		DECLARE @Nombre VARCHAR(250) = '';
		DECLARE @IdMovimientoTesoreria INT;
		DECLARE @IdAsiento INT;
		
		IF @FlagBorrador = 0
		BEGIN
			SET @Orden = (ISNULL((SELECT MAX(Orden) FROM ERP.MovimientoCajaChica WHERE IdEmpresa = @IdEmpresa AND IdPeriodo = @IdPeriodo AND IdCuenta = @IdCuenta AND Flag = 1 AND FlagBorrador = 0),0) + 1)
			SET @Nombre = 'CAJA CHICA N° ' +  CAST(@Orden AS VARCHAR(10));
		END 

		INSERT INTO ERP.MovimientoCajaChica(Orden
											,IdEmpresa
											,IdCuenta
											,IdPeriodo
											,TipoCambio
											,FechaEmision
											,SaldoInicial
											,TotalGastado
											,SaldoFinal
											,FechaRegistro
											,UsuarioRegistro
											,FechaModificado
											,UsuarioModifico
											,FlagBorrador
											,Flag
											)
		SELECT
			@Orden,
			T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
			CASE WHEN (T.N.value('IdCuenta[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdCuenta[1]',			'INT')
			END														AS IdCuenta,
			@IdPeriodo,									
			T.N.value('TipoCambio[1]',			'DECIMAL(14,5)')	AS TipoCambio,
			T.N.value('FechaEmision[1]',		'DATETIME')		AS FechaEmision,
			T.N.value('SaldoInicial[1]',				'DECIMAL(14,5)')	AS Saldo,
			T.N.value('TotalGastado[1]',		'DECIMAL(14,5)')	AS TotalGastado,
			T.N.value('SaldoFinal[1]',		'DECIMAL(14,5)')		AS SaldoFinal,
			DATEADD(HOUR, 3, GETDATE())								AS FechaRegistro,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
			DATEADD(HOUR, 3, GETDATE())								AS FechaRegistro,
			T.N.value('UsuarioRegistro[1]',		'VARCHAR(250)')		AS UsuarioRegistro,
			T.N.value('FlagBorrador[1]',		'BIT')				AS FlagBorrador,
			CAST(1 AS BIT)											AS Flag
		FROM @XMLCajaChica.nodes('/ArchivoPlanoCajaChica')	AS T(N)
		SET @IdCajaChica = SCOPE_IDENTITY()

		INSERT INTO [ERP].[MovimientoCajaChicaDetalle](
										IdMovimientoCajaChica
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
				@IdCajaChica												AS IdMovimientoCajaChica,
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
				FROM @XMLCajaChica.nodes('/ListaArchivoPlanoCajaChicaDetalle/ArchivoPlanoCajaChicaDetalle') AS T(N)

		-----SE REGISTRA EL MOVIMIENTO DE CAJA CHICA Y SE GENERA LOS ASIENTOS 
		IF @FlagBorrador = 0
		BEGIN
			EXEC ERP.Usp_Ins_CajaChica_MovimientoTesoreria @IdMovimientoTesoreria OUT, @XMLCajaChica, @Nombre, @IdEmpresa, @IdPeriodo

			UPDATE ERP.MovimientoCajaChica SET IdMovimientoTesoreriaGenerado = @IdMovimientoTesoreria WHERE ID = @IdCajaChica

			SET @IdAsiento = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreria);

			UPDATE ERP.Asiento SET Nombre = @Nombre + ' - ' + Nombre WHERE ID = @IdAsiento
		END
		SET NOCOUNT OFF;

END