CREATE PROC [ERP].[Usp_Sel_TotalMovimiento_By_IdCuenta_IdTipoMovimiento_Fecha]
@IdCuenta INT,
@IdTipoMovimiento INT,
@Fecha DATETIME
AS
BEGIN

	DECLARE @TotalMovimiento DECIMAL(14,5) = (SELECT SUM(Total) FROM ERP.MovimientoTesoreria
											  WHERE IdCuenta = @IdCuenta AND IdTipoMovimiento = @IdTipoMovimiento
											  AND CAST(Fecha AS DATE) < CAST(@Fecha AS DATE) AND Flag = 1 AND FlagBorrador = 0)

	DECLARE @SaldoInicialDebe DECIMAL(14,5) = (SELECT SaldoInicialDebe
											  FROM ERP.Cuenta
											  WHERE Flag = 1 AND FlagBorrador = 0 AND ID = @IdCuenta)

	DECLARE @SaldoInicialHaber DECIMAL(14,5) = (SELECT SaldoInicialHaber
												FROM ERP.Cuenta
												WHERE Flag = 1 AND FlagBorrador = 0 AND ID = @IdCuenta)

IF @IdTipoMovimiento = 1

	SELECT ISNULL(@TotalMovimiento,0) + ISNULL(@SaldoInicialDebe,0)

ELSE

	SELECT ISNULL(@TotalMovimiento,0) + ISNULL(@SaldoInicialHaber,0)

END