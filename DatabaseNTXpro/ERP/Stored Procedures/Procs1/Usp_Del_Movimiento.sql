CREATE PROC [ERP].[Usp_Del_Movimiento]
@IdMovimientoTesoreria INT
AS
BEGIN
	DELETE FROM [ERP].[MovimientoTesoreriaDetalleCuentaPagar] WHERE IdMovimientoTesoreriaDetalle IN  (SELECT MTD.ID FROM ERP.MovimientoTesoreria MT INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.IdMovimientoTesoreria = MT.ID WHERE MT.ID = @IdMovimientoTesoreria AND MTD.IdDebeHaber = 1)
	DELETE FROM [ERP].[MovimientoTesoreriaDetalleCuentaCobrar]WHERE IdMovimientoTesoreriaDetalle IN  (SELECT MTD.ID FROM ERP.MovimientoTesoreria MT INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.IdMovimientoTesoreria = MT.ID WHERE MT.ID = @IdMovimientoTesoreria AND MTD.IdDebeHaber = 2)
	DELETE FROM [ERP].[MovimientoTesoreriaDetalle] WHERE IdMovimientoTesoreria = @IdMovimientoTesoreria
	DELETE FROM [ERP].[MovimientoTesoreria] WHERE ID = @IdMovimientoTesoreria
	
END