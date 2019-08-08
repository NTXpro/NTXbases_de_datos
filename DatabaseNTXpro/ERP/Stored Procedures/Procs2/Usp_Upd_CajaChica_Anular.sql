
CREATE PROC [ERP].[Usp_Upd_CajaChica_Anular]
@ID INT
AS
BEGIN
	DECLARE @IdMovimientoTesoreria INT = (SELECT IdMovimientoTesoreriaGenerado FROM ERP.MovimientoCajaChica WHERE ID = @ID)
	DECLARE @IdAsiento INT = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @IdMovimientoTesoreria)

	---==== SE REALIZA ANULACION DE CAJA CHICA ====-------
	UPDATE ERP.MovimientoCajaChica SET Flag = 0 WHERE ID = @ID

	---==== SE REALIZA ANULACION DE MOVIMIENTOS GENERADOS POR CxP ====-------
	UPDATE ERP.MovimientoTesoreria SET Flag = 0 WHERE ID = @IdMovimientoTesoreria
	
	---==== SE REALIZA ANULACION DE MOVIMIENTOS GENERADOS POR TRANSFERENCIA ====-------
	UPDATE ERP.MovimientoTesoreria SET Flag = 0 
	WHERE ID IN (SELECT IdMovimientoTesoreria FROM ERP.MovimientoCajaChicaDetalle WHERE IdMovimientoCajaChica = @ID)

	---==== SE HABILITA LAS CxP ====-------
	UPDATE ERP.CuentaPagar SET FlagCancelo = 0 WHERE
	ID IN (SELECT IdCuentaPagar FROM ERP.MovimientoCajaChicaDetalle WHERE IdMovimientoCajaChica = @ID)  
	
	--== SE MODIFICA EL ASIENTO ==--
	UPDATE ERP.AsientoDetalle SET ImporteDolares = 0, ImporteSoles = 0 WHERE IdAsiento = @IdAsiento 
END
