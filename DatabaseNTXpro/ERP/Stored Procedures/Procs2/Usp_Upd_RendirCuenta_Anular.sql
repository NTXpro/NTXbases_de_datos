
CREATE PROC [ERP].[Usp_Upd_RendirCuenta_Anular]
@ID int
AS
BEGIN
	DECLARE @IdMovimientoTesoreria INT = (SELECT IdMovimientoTesoreria FROM ERP.MovimientoRendirCuenta WHERE ID = @ID)
	DECLARE @IdMovimientoTesoreriaGenerado INT = (SELECT IdMovimientoTesoreriaGenerado FROM ERP.MovimientoRendirCuenta WHERE ID = @ID)
	DECLARE @IdAsiento INT = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreriaGenerado)

	---==== SE REALIZA ANULACION DE CAJA CHICA ====-------
	UPDATE ERP.MovimientoRendirCuenta SET Flag = 0 WHERE ID = @ID

	---==== SE REALIZA ANULACION DE CAJA CHICA ====-------
	UPDATE ERP.MovimientoTesoreria SET FlagRindioCuenta = 0 WHERE ID = @IdMovimientoTesoreria

	---==== SE REALIZA ANULACION DE MOVIMIENTOS GENERADOS POR CxP ====-------
	UPDATE ERP.MovimientoTesoreria SET Flag = 0 WHERE ID = @IdMovimientoTesoreriaGenerado
	
	---==== SE REALIZA ANULACION DE MOVIMIENTOS GENERADOS POR TRANSFERENCIA ====-------
	UPDATE ERP.MovimientoTesoreria SET Flag = 0 
	WHERE ID IN (SELECT IdMovimientoTesoreria FROM ERP.MovimientoRendirCuentaDetalle WHERE IdMovimientoRendirCuenta = @ID)

	---==== SE HABILITA LAS CxP ====-------
	UPDATE ERP.CuentaPagar SET FlagCancelo = 0 WHERE
	ID IN (SELECT IdCuentaPagar FROM ERP.MovimientoRendirCuentaDetalle WHERE IdMovimientoRendirCuenta = @ID)  
	
	--== SE MODIFICA EL ASIENTO ==--
	UPDATE ERP.AsientoDetalle SET ImporteDolares = 0, ImporteSoles = 0 WHERE IdAsiento = @IdAsiento 
END