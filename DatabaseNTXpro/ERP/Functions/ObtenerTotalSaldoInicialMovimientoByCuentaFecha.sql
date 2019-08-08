/*SE OBTIENE EL SALDO INICIAL DE LA CUENTA A PARTIR DE UNA CIERTA FECHA HACIA ATRAS
EJEMPLO: CUENTA 1 , FECHA ENERO 2015
SE OBTIENE EL MONTO INICIAL HASTA ESA FECHA
OSEA LOS MOVIMIENTOS GENERADOS EN ENERO NO SE DEBEN VISUALIZAR SOLO LOS DE ENERO HACIA ATRAS(...NOVIEMBRE,DICIEMBRE 2014)
*/
CREATE FUNCTION [ERP].[ObtenerTotalSaldoInicialMovimientoByCuentaFecha](
@IdEmpresa INT,
@IdCuenta INT,
@Mes INT,
@Anio INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN
	DECLARE @SaldoInicialCuenta DECIMAL(14,5) = 0
	DECLARE @SaldoInicialHaber DECIMAL(14,5) = (SELECT SUM(ISNULL(SaldoInicialHaber,0)) FROM ERP.Cuenta WHERE (@IdCuenta = 0 OR ID = @IdCuenta) AND IdEmpresa = @IdEmpresa)
	DECLARE @SaldoInicialDebe DECIMAL(14,5) = (SELECT SUM(ISNULL(SaldoInicialDebe,0)) FROM ERP.Cuenta WHERE (@IdCuenta = 0 OR ID = @IdCuenta) AND IdEmpresa = @IdEmpresa)
	SET @SaldoInicialCuenta = @SaldoInicialHaber - @SaldoInicialDebe;

	DECLARE @TotalIngresoMovimiento DECIMAL(14,5) = (SELECT SUM(CASE WHEN @IdCuenta = 0 AND C.IdMoneda = 2 THEN ---SI LA CUENTA ES TODOS LOS MONTOS DEBEN SER EN SOLES
																	MT.Total / MT.TipoCambio
																ELSE
																	MT.Total
																END)
														FROM ERP.MovimientoTesoreria MT
														INNER JOIN ERP.Cuenta C ON  C.ID = MT.IdCuenta
														WHERE (@IdCuenta = 0 OR MT.IdCuenta = @IdCuenta)   
														 AND ((YEAR(MT.Fecha) = @Anio AND MONTH(MT.Fecha) < @Mes) OR (YEAR(MT.Fecha) < @Anio))
														AND MT.IdTipoMovimiento = 1 AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.IdEmpresa = @IdEmpresa
														--ingreso
														)

	DECLARE @TotalSalidaMovimiento DECIMAL(14,5) = (SELECT SUM(CASE WHEN @IdCuenta = 0 AND C.IdMoneda = 2 THEN ---SI LA CUENTA ES TODOS LOS MONTOS DEBEN SER EN SOLES
																	MT.Total / MT.TipoCambio
																ELSE
																	MT.Total
																END)
														FROM ERP.MovimientoTesoreria MT
														INNER JOIN ERP.Cuenta C ON  C.ID = MT.IdCuenta
														WHERE (@IdCuenta = 0 OR MT.IdCuenta = @IdCuenta)  
														AND ((YEAR(MT.Fecha) = @Anio AND MONTH(MT.Fecha) < @Mes) OR (YEAR(MT.Fecha) < @Anio))
														AND MT.IdTipoMovimiento = 2 AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.IdEmpresa = @IdEmpresa
														--salida
														)

	DECLARE @SaldoInicialTotal DECIMAL(14,5)= ISNULL(@SaldoInicialCuenta,0) + ISNULL(@TotalIngresoMovimiento,0) - ISNULL(@TotalSalidaMovimiento,0);

	RETURN @SaldoInicialTotal
END
