
CREATE PROC [ERP].[Usp_Sel_TotalMovimiento_By_IdCuenta_TipoMovimiento_FlagConciliado]
@IdCuenta INT,
@IdTipoMovimiento INT,
@FlagConciliado BIT,
@Anio INT,
@Mes INT
AS
BEGIN
	DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdMes = @Mes AND IdAnio = (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio))
	DECLARE @TotalMovimientoConciliado DECIMAL(14,5)

	SET @TotalMovimientoConciliado = (SELECT SUM(MT.Total) 
									FROM ERP.MovimientoTesoreria MT
									INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
									WHERE IdTipoMovimiento = @IdTipoMovimiento AND IdPeriodo = @IdPeriodo AND FlagConciliado = @FlagConciliado
									AND MT.FlagBorrador = 0 AND MT.Flag = 1 AND MT.IdCuenta = @IdCuenta)

	SELECT ISNULL(@TotalMovimientoConciliado,0)
END