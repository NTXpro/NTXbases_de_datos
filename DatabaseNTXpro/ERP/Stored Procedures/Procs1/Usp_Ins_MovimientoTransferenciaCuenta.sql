
CREATE PROCEDURE [ERP].[Usp_Ins_MovimientoTransferenciaCuenta]
@IdTransferencia INT OUTPUT,
@XMLMovimientoTransferencia XML,
@XMLMovimientoTesoreriaEmisor XML,
@XMLMovimientoTesoreriaReceptor XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		--SET NOCOUNT ON;

		DECLARE @IdMovimientoTesoreriaEmisor INT;
		DECLARE @IdMovimientoTesoreriaReceptor INT;
		DECLARE @FlagBorrador BIT= (SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLMovimientoTransferencia.nodes('/ArchivoPlanoTransferencia')	AS T(N))

		IF @FlagBorrador = 0
		BEGIN
			EXEC ERP.Usp_Ins_MovimientoTesoreria @IdMovimientoTesoreriaEmisor OUT, @XMLMovimientoTesoreriaEmisor
			EXEC ERP.Usp_Ins_MovimientoTesoreria @IdMovimientoTesoreriaReceptor OUT, @XMLMovimientoTesoreriaReceptor
		END

		INSERT INTO ERP.MovimientoTransferenciaCuenta( IdEmpresa      
													  ,IdMovimientoTesoreriaEmisor
													  ,IdCuentaEmisor
													  ,IdCategoriaTipoMovimientoEmisor
													  ,IdTalonarioEmisor
													  ,NumeroChequeEmisor
													  ,FechaEmisor
													  ,FechaVencimientoEmisor
													  ,TipoCambioEmisor
													  ,MontoEmisor
													  ,DocumentoEmisor
													  ,OrdenDeEmisor
													  ,AjusteEmisor
													  ,ConceptoEmisor
													  ,ObservacionEmisor
													  ,IdMovimientoTesoreriaReceptor
													  ,IdCuentaReceptor
													  ,IdCategoriaTipoMovimientoReceptor
													  ,FechaReceptor
													  ,DocumentoReceptor
													  ,TipoCambioReceptor
													  ,MontoReceptor
													  ,ConceptoReceptor
													  ,ObservacionReceptor
													  ,Flag
													  ,FlagCheque
													  ,FlagChequeDiferido
													  ,FlagBorrador)
		SELECT
			T.N.value('IdEmpresa[1]',			'INT')				AS IdEmpresa,
			@IdMovimientoTesoreriaEmisor,
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
			T.N.value('DocumentoEmisor[1]',				'VARCHAR(25)')	AS DocumentoEmisor,
			T.N.value('OrdenDeEmisor[1]',				'VARCHAR(250)')	AS OrdenDeEmisor,
			T.N.value('AjusteEmisor[1]',				'DECIMAL(14,5)')	AS AjusteEmisor,
			T.N.value('ConceptoEmisor[1]',				'VARCHAR(250)')	AS ConceptoEmisor,
			T.N.value('ObservacionEmisor[1]',				'VARCHAR(250)')	AS ObservacionEmisor,
			@IdMovimientoTesoreriaReceptor,
			CASE WHEN (T.N.value('IdCuentaReceptor[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdCuentaReceptor[1]','INT')
			END														AS IdCuentaReceptor,	
			CASE WHEN (T.N.value('IdCategoriaTipoMovimientoReceptor[1]','INT') = 0) THEN
				NULL
			ELSE 
				T.N.value('IdCategoriaTipoMovimientoReceptor[1]','INT')
			END														AS IdCategoriaTipoMovimientoReceptor,
			T.N.value('FechaReceptor[1]',				'DATETIME')	AS FechaReceptor,
			T.N.value('DocumentoReceptor[1]',				'VARCHAR(25)')	AS DocumentoReceptor,
			T.N.value('TipoCambioReceptor[1]',				'DECIMAL(14,5)')	AS TipoCambioReceptor,
			T.N.value('MontoReceptor[1]',				'DECIMAL(14,5)')	AS MontoReceptor,
			T.N.value('ConceptoReceptor[1]',				'VARCHAR(250)')	AS ConceptoReceptor,
			T.N.value('ObservacionReceptor[1]',				'VARCHAR(250)')	AS ObservacionReceptor,
			CAST(1 AS BIT),
			T.N.value('FlagCheque[1]',				'BIT')		AS FlagCheque,
			T.N.value('FlagChequeDiferido[1]',				'BIT')	AS FlagChequeDiferido,
			T.N.value('FlagBorrador[1]',				'BIT')	AS FlagBorrador
		FROM @XMLMovimientoTransferencia.nodes('/ArchivoPlanoTransferencia')	AS T(N)
		SET @IdTransferencia = SCOPE_IDENTITY()
		
		IF @FlagBorrador = 0
		BEGIN
			DECLARE @IdAsiento INT =(SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreriaEmisor)

			DECLARE @NombreAsiento VARCHAR(250) = (SELECT UPPER('TRANSFERENCIA ENTRE '+CE.Nombre+' A '+CR.Nombre)
													FROM ERP.MovimientoTransferenciaCuenta MTC 
													LEFT JOIN ERP.Cuenta CE ON CE.ID = MTC.IdCuentaEmisor
													LEFT JOIN ERP.Cuenta CR ON CR.ID = MTC.IdCuentaReceptor
													WHERE MTC.IdMovimientoTesoreriaEmisor = @IdMovimientoTesoreriaEmisor)

			UPDATE ERP.Asiento set Nombre = @NombreAsiento WHERE ID = @IdAsiento
		END

		--SET NOCOUNT OFF;
END
