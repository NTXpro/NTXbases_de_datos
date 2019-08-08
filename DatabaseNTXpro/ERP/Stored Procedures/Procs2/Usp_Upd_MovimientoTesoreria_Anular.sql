
CREATE PROC [ERP].[Usp_Upd_MovimientoTesoreria_Anular]
@ID INT
AS
BEGIN
	DECLARE @IdAsiento INT = (SELECT IdAsiento FROM ERP.MovimientoTesoreria WHERE ID = @ID)
	
	UPDATE ERP.MovimientoTesoreria SET Flag = 0 WHERE ID = @ID
	UPDATE ERP.AsientoDetalle SET ImporteDolares = 0, ImporteSoles = 0 WHERE IdAsiento = @IdAsiento

	UPDATE ERP.CuentaCobrar SET FlagCancelo = 0 
	WHERE ID IN (SELECT MTDC.IdCuentaCobrar 
				 FROM ERP.MovimientoTesoreriaDetalle MTD
				 INNER JOIN [ERP].[MovimientoTesoreriaDetalleCuentaCobrar] MTDC ON MTDC.IdMovimientoTesoreriaDetalle = MTD.ID
				 WHERE MTD.IdMovimientoTesoreria = @ID AND MTD.PagarCobrar = 'C')

	UPDATE ERP.CuentaPagar SET FlagCancelo = 0 
	WHERE ID IN (SELECT MTDP.IdCuentaPagar 
				 FROM ERP.MovimientoTesoreriaDetalle MTD
				 INNER JOIN [ERP].[MovimientoTesoreriaDetalleCuentaPagar] MTDP ON MTDP.IdMovimientoTesoreriaDetalle = MTD.ID
				 WHERE MTD.IdMovimientoTesoreria = @ID AND MTD.PagarCobrar = 'P')
END

