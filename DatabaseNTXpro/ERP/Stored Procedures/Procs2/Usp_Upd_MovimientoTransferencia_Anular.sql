
CREATE PROC [ERP].[Usp_Upd_MovimientoTransferencia_Anular]
@ID INT
AS
BEGIN
	DECLARE @IdMovimientoTesoreriaEmisor INT = (SELECT IdMovimientoTesoreriaEmisor FROM ERP.MovimientoTransferenciaCuenta WHERE ID = @ID)
	DECLARE @IdMovimientoTesoreriaReceptor INT = (SELECT IdMovimientoTesoreriaReceptor FROM ERP.MovimientoTransferenciaCuenta WHERE ID = @ID)
	DECLARE @IdAsientoEmisor INT = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreriaEmisor)
	DECLARE @IdAsientoReceptor INT = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreriaReceptor)

	UPDATE ERP.AsientoDetalle SET ImporteSoles = 0, ImporteDolares = 0 WHERE IdAsiento = @IdAsientoEmisor
	UPDATE ERP.AsientoDetalle SET ImporteSoles = 0, ImporteDolares = 0 WHERE IdAsiento = @IdAsientoReceptor

	UPDATE ERP.MovimientoTesoreria SET Flag = 0  WHERE ID IN (@IdMovimientoTesoreriaEmisor, @IdMovimientoTesoreriaReceptor) 
	UPDATE ERP.MovimientoTransferenciaCuenta SET Flag = 0 WHERE ID = @ID
END
