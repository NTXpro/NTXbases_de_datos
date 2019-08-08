
CREATE PROCEDURE [ERP].[Usp_Upd_MovimientoTransferenciaCuenta]
@IdTransferencia INT,
@XMLMovimientoTransferencia XML,
@XMLMovimientoTesoreriaEmisor XML,
@XMLMovimientoTesoreriaReceptor XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;

		DECLARE @IdMovimientoTesoreriaEmisor INT = (SELECT IdMovimientoTesoreriaEmisor FROM ERP.MovimientoTransferenciaCuenta WHERE ID = @IdTransferencia);
		DECLARE @IdMovimientoTesoreriaReceptor INT = (SELECT IdMovimientoTesoreriaReceptor FROM ERP.MovimientoTransferenciaCuenta WHERE ID = @IdTransferencia);
		DECLARE @FlagBorrador BIT= (SELECT T.N.value('FlagBorrador[1]','BIT') FROM @XMLMovimientoTransferencia.nodes('/ArchivoPlanoTransferencia')	AS T(N))

		IF @FlagBorrador = 0 AND @IdMovimientoTesoreriaEmisor IS NULL 
		BEGIN
			EXEC ERP.Usp_Ins_MovimientoTesoreria @IdMovimientoTesoreriaEmisor OUT, @XMLMovimientoTesoreriaEmisor
			EXEC ERP.Usp_Ins_MovimientoTesoreria @IdMovimientoTesoreriaReceptor OUT, @XMLMovimientoTesoreriaReceptor
		END

		UPDATE ERP.MovimientoTransferenciaCuenta SET
		IdMovimientoTesoreriaEmisor = @IdMovimientoTesoreriaEmisor,
		IdCuentaEmisor = CASE WHEN (T.N.value('IdCuentaEmisor[1]','INT') = 0) THEN
							NULL
						ELSE 
							T.N.value('IdCuentaEmisor[1]','INT')
						END,
		IdCategoriaTipoMovimientoEmisor = CASE WHEN (T.N.value('IdCategoriaTipoMovimientoEmisor[1]','INT') = 0) THEN
												NULL
											ELSE 
												T.N.value('IdCategoriaTipoMovimientoEmisor[1]','INT')
											END,
		IdTalonarioEmisor = CASE WHEN (T.N.value('IdTalonarioEmisor[1]','INT') = 0) THEN
								NULL
							ELSE 
								T.N.value('IdTalonarioEmisor[1]','INT')
							END,
		NumeroChequeEmisor = T.N.value('NumeroChequeEmisor[1]','INT'),
		FechaEmisor = T.N.value('FechaEmisor[1]','DATETIME'),
		FechaVencimientoEmisor = T.N.value('FechaVencimientoEmisor[1]','DATETIME'),
		TipoCambioEmisor = T.N.value('TipoCambioEmisor[1]','DECIMAL(14,5)'),
		MontoEmisor = T.N.value('MontoEmisor[1]','DECIMAL(14,5)'),
		DocumentoEmisor = T.N.value('DocumentoEmisor[1]','VARCHAR(25)'),
		OrdenDeEmisor = T.N.value('OrdenDeEmisor[1]','VARCHAR(250)'),
		AjusteEmisor = T.N.value('AjusteEmisor[1]','DECIMAL(14,5)'),
		ConceptoEmisor = T.N.value('ConceptoEmisor[1]','VARCHAR(250)'),
		ObservacionEmisor = T.N.value('ObservacionEmisor[1]','VARCHAR(250)'),
		IdMovimientoTesoreriaReceptor = @IdMovimientoTesoreriaReceptor,
		IdCuentaReceptor = CASE WHEN (T.N.value('IdCuentaReceptor[1]','INT') = 0) THEN
								NULL
							ELSE 
								T.N.value('IdCuentaReceptor[1]','INT')
							END,
		IdCategoriaTipoMovimientoReceptor = CASE WHEN (T.N.value('IdCategoriaTipoMovimientoReceptor[1]','INT') = 0) THEN
												NULL
											ELSE 
												T.N.value('IdCategoriaTipoMovimientoReceptor[1]','INT')
											END,
		FechaReceptor = T.N.value('FechaReceptor[1]','DATETIME'),
		DocumentoReceptor = T.N.value('DocumentoReceptor[1]','VARCHAR(25)'),
		TipoCambioReceptor = T.N.value('TipoCambioReceptor[1]','DECIMAL(14,5)'),
		MontoReceptor = T.N.value('MontoReceptor[1]','DECIMAL(14,5)'),
		ConceptoReceptor = T.N.value('ConceptoReceptor[1]','VARCHAR(250)'),
		ObservacionReceptor = T.N.value('ObservacionReceptor[1]','VARCHAR(250)'),
		FlagBorrador = T.N.value('FlagBorrador[1]','BIT'),
		FlagCheque = T.N.value('FlagCheque[1]','BIT'),
		FlagChequeDiferido = T.N.value('FlagChequeDiferido[1]','BIT')
		FROM @XMLMovimientoTransferencia.nodes('/ArchivoPlanoTransferencia') AS T(N)
		WHERE ID = @IdTransferencia

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


		SET NOCOUNT OFF;
END
