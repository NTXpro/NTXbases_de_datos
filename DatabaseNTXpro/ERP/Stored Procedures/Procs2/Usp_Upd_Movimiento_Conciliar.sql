CREATE PROC [ERP].[Usp_Upd_Movimiento_Conciliar]
@IdConciliacion INT,
@IdMovimiento INT,
@Checked BIT
AS
BEGIN
	IF @Checked = 1
	BEGIN
		UPDATE ERP.MovimientoTesoreria SET FlagConciliado = 1, IdMovimientoConciliacion = @IdConciliacion WHERE ID = @IdMovimiento
	END
	ELSE
	BEGIN
		UPDATE ERP.MovimientoTesoreria SET FlagConciliado = 0, IdMovimientoConciliacion = 0 WHERE ID = @IdMovimiento
	END
END