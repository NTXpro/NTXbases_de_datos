
CREATE PROCEDURE ERP.Usp_Del_MovimientoTesoreriaDetalle
@ID INT
AS
	DECLARE @Orden INTEGER
	DECLARE @IdMovimientoTesoreria INTEGER

	SELECT @Orden = Orden, @IdMovimientoTesoreria = IdMovimientoTesoreria
	FROM ERP.MovimientoTesoreriaDetalle
	WHERE ID = @ID

	DELETE FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar
	WHERE IdMovimientoTesoreriaDetalle = @ID

	DELETE FROM  ERP.MovimientoTesoreriaDetalleCuentaPagar
	WHERE IdMovimientoTesoreriaDetalle = @ID

	DELETE
	FROM ERP.MovimientoTesoreriaDetalle
	WHERE ID = @ID	

	UPDATE ERP.MovimientoTesoreriaDetalle
	SET Orden = Orden - 1
	WHERE Orden > @Orden
	AND @IdMovimientoTesoreria = IdMovimientoTesoreria
