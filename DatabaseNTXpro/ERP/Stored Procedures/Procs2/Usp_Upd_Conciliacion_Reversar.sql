CREATE PROC [ERP].[Usp_Upd_Conciliacion_Reversar]
@IdConciliacion INT
AS
BEGIN
	UPDATE ERP.MovimientoTesoreria SET FlagConciliado = 0, IdMovimientoConciliacion = NULL WHERE IdMovimientoConciliacion = @IdConciliacion
	DELETE FROM ERP.MovimientoConciliacionPendiente WHERE IdMovimientoConciliacion = @IdConciliacion	
	DELETE FROM ERP.MovimientoConciliacion WHERE ID = @IdConciliacion
END
