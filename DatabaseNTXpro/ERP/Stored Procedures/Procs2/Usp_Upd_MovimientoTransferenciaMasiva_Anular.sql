
CREATE PROC [ERP].[Usp_Upd_MovimientoTransferenciaMasiva_Anular]
@ID INT
AS
BEGIN
	DECLARE @IdMovimientoTesoreriaEmisor INT = (SELECT IdMovimientoTesoreriaEmisor FROM ERP.MovimientoTransferenciaMasivaCuenta WHERE ID = @ID)
	DECLARE @IdAsientoEmisor INT = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreriaEmisor)

	--ANULAR ASIENTO EMISOR
	UPDATE ERP.AsientoDetalle SET ImporteSoles = 0, ImporteDolares = 0 WHERE IdAsiento = @IdAsientoEmisor

	--ANULAR MOVIMIENTO EMISOR
	UPDATE ERP.MovimientoTesoreria SET Flag = 0  WHERE ID IN (@IdMovimientoTesoreriaEmisor) 

	--ANULAR MOVIMIENTO RECEPTOR

	UPDATE ERP.MovimientoTesoreria SET Flag = 0  WHERE ID IN (SELECT IdMovimientoTesoreriaReceptor FROM ERP.MovimientoTransferenciaMasivaCuentaDetalle WHERE IdMovimientoTransferenciaMasivaCuenta = @ID) 

	--ANULAR TRANSFERENCIA
	UPDATE ERP.MovimientoTransferenciaMasivaCuenta SET Flag = 0 WHERE ID = @ID
END
