
CREATE FUNCTION [ERP].[ObtenerTotalMovimientoConciliadoByCuentaFecha](
@IdCuenta INT,
@Fecha DATETIME
)
RETURNS DECIMAL(14,5)
AS
BEGIN
	DECLARE @SaldoInicialCuenta DECIMAL(14,5) = 0
	DECLARE @TotalMovimientoIngreso DECIMAL(14,5) = 0
	DECLARE @TotalMovimientoSalida DECIMAL(14,5) = 0
	DECLARE @TotalMovimiento DECIMAL(14,5) = 0
	DECLARE @SaldoInicialHaber DECIMAL(14,5) = (SELECT SUM(ISNULL(SaldoInicialHaber,0)) FROM ERP.Cuenta WHERE  ID = @IdCuenta)
	DECLARE @SaldoInicialDebe DECIMAL(14,5) = (SELECT SUM(ISNULL(SaldoInicialDebe,0)) FROM ERP.Cuenta WHERE ID = @IdCuenta)
	SET @SaldoInicialCuenta = @SaldoInicialDebe - @SaldoInicialHaber;

	SET @TotalMovimientoIngreso = (SELECT SUM(MT.Total) 
							FROM ERP.MovimientoTesoreria MT
							WHERE IdCuenta = @IdCuenta AND CAST(Fecha AS DATE) <= CAST(@Fecha AS DATE)
							AND Flag = 1 AND FlagBorrador = 0 AND FlagConciliado = 1 AND IdTipoMovimiento = 1);

	SET @TotalMovimientoSalida = (SELECT SUM(MT.Total) 
							FROM ERP.MovimientoTesoreria MT
							WHERE IdCuenta = @IdCuenta AND CAST(Fecha AS DATE) <= CAST(@Fecha AS DATE)
							AND Flag = 1 AND FlagBorrador = 0 AND FlagConciliado = 1 AND IdTipoMovimiento = 2);

	SET @TotalMovimiento = ISNULL(@TotalMovimientoIngreso,0) + @SaldoInicialCuenta - ISNULL(@TotalMovimientoSalida,0)

	RETURN @TotalMovimiento;
END


