CREATE PROC [ERP].[Usp_Sel_SaldoMovimiento] --1,1,1
@IdCuenta INT,
@IdEmpresa INT,
@Mes INT,
@Anio INT
AS
BEGIN
	
	DECLARE @SaldoInicialCuenta DECIMAL(14,5) = (SELECT [ERP].[ObtenerTotalSaldoInicialMovimientoByCuentaFecha](@IdEmpresa, @IdCuenta, @Mes, @Anio))

	DECLARE @TotalIngresoMovimiento DECIMAL(14,5) = (SELECT SUM(CASE WHEN C.IdMoneda = 1 THEN
																	MT.Total
																ELSE
																	 MT.Total * MT.TipoCambio
																END)
														FROM ERP.MovimientoTesoreria MT
														INNER JOIN ERP.Cuenta C ON  C.ID = MT.IdCuenta
														WHERE MT.IdCuenta = @IdCuenta AND MONTH(MT.Fecha) = @Mes AND YEAR(MT.Fecha) = @Anio AND MT.IdTipoMovimiento = 1 --ingreso
														AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.IdEmpresa = @IdEmpresa
														)

	DECLARE @TotalSalidaMovimiento DECIMAL(14,5) = (SELECT SUM(CASE WHEN C.IdMoneda = 1 THEN
																	MT.Total
																ELSE
																	 MT.Total * MT.TipoCambio
																END)
														FROM ERP.MovimientoTesoreria MT
														INNER JOIN ERP.Cuenta C ON  C.ID = MT.IdCuenta
														WHERE MT.IdCuenta = @IdCuenta AND MONTH(MT.Fecha) = @Mes AND YEAR(MT.Fecha) = @Anio AND MT.IdTipoMovimiento = 2 --salida
														AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.IdEmpresa = @IdEmpresa
														)
	DECLARE @SaldoInicialTotal DECIMAL(14,5)= ISNULL(@SaldoInicialCuenta,0) + ISNULL(@TotalIngresoMovimiento,0) - ISNULL(@TotalSalidaMovimiento,0);

	SELECT @SaldoInicialTotal
END
