
CREATE PROC [ERP].[Usp_Sel_TotalMovimientoConciliado_By_IdConciliacion_TipoMovimiento]
@IdConciliacion INT,
@IdTipoMovimiento INT
AS
BEGIN
	DECLARE @TotalMovimientoConciliado DECIMAL(14,5)

	SET @TotalMovimientoConciliado = (SELECT SUM(MT.Total) 
									FROM ERP.MovimientoTesoreria MT
									INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
									WHERE IdTipoMovimiento = @IdTipoMovimiento AND IdMovimientoConciliacion = @IdConciliacion AND MT.Flag = 1)

	SELECT ISNULL(@TotalMovimientoConciliado,0)
END