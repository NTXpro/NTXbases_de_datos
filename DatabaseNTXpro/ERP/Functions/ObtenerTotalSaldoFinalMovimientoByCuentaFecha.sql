CREATE FUNCTION [ERP].[ObtenerTotalSaldoFinalMovimientoByCuentaFecha](
@IdEmpresa INT,
@IdCuenta INT,
@Mes INT,
@Anio INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN
	
	DECLARE @SaldoInicialCuenta DECIMAL(14,5) = (SELECT [ERP].[ObtenerTotalSaldoInicialMovimientoByCuentaFecha](@IdEmpresa, @IdCuenta, @Mes, @Anio))

	DECLARE @TotalIngresoMovimiento DECIMAL(14,5) = (SELECT SUM(CASE WHEN @IdCuenta = 0 AND C.IdMoneda = 2 THEN ---SI LA CUENTA ES TODOS LOS MONTOS DEBEN SER EN SOLES
																	MT.Total / MT.TipoCambio
																ELSE
																	MT.Total
																END)
														FROM ERP.MovimientoTesoreria MT
														INNER JOIN ERP.Cuenta C ON  C.ID = MT.IdCuenta
														WHERE (@IdCuenta = 0 OR MT.IdCuenta = @IdCuenta) AND MONTH(MT.Fecha) = @Mes AND YEAR(MT.Fecha) = @Anio AND MT.IdTipoMovimiento = 1 --ingreso
														AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.IdEmpresa = @IdEmpresa
														)

	DECLARE @TotalSalidaMovimiento DECIMAL(14,5) = (SELECT SUM(CASE WHEN @IdCuenta = 0 AND C.IdMoneda = 2 THEN ---SI LA CUENTA ES TODOS LOS MONTOS DEBEN SER EN SOLES
																	MT.Total / MT.TipoCambio
																ELSE
																	MT.Total
																END)
														FROM ERP.MovimientoTesoreria MT
														INNER JOIN ERP.Cuenta C ON  C.ID = MT.IdCuenta
														WHERE (@IdCuenta = 0 OR MT.IdCuenta = @IdCuenta) AND MONTH(MT.Fecha) = @Mes AND YEAR(MT.Fecha) = @Anio AND MT.IdTipoMovimiento = 2 --salida
														AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.IdEmpresa = @IdEmpresa
														)

	DECLARE @SaldoInicialTotal DECIMAL(14,5)= ISNULL(@SaldoInicialCuenta,0) + ISNULL(@TotalIngresoMovimiento,0) - ISNULL(@TotalSalidaMovimiento,0);

	RETURN @SaldoInicialTotal
END
