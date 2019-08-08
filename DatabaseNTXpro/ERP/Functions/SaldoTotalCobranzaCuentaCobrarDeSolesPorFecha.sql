CREATE FUNCTION [ERP].[SaldoTotalCobranzaCuentaCobrarDeSolesPorFecha] (@IdCuentaCobrar INT,@Fecha DATETIME)
RETURNS DECIMAL(14,5)
AS
BEGIN  
			DECLARE @TotalCuentaCobrar DECIMAL(14,5);
			DECLARE @TotalMovimientoCuentaCobrar DECIMAL(14,5);
			DECLARE @TotalSaldo DECIMAL(14,5);

			SET @TotalCuentaCobrar = (SELECT Total FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrar)

			SET @TotalMovimientoCuentaCobrar = (SELECT SUM (CASE WHEN MT.IdMoneda = 1 AND CC.IdMoneda = 1 THEN
																		MTD.Total
															WHEN MT.IdMoneda = 2 AND CC.IdMoneda = 1 THEN
																		ROUND((MTD.Total * MT.TipoCambio),2)
																		END
																		)
														FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
														INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
														INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
														INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MDCC.IdCuentaCobrar
														WHERE CC.ID = @IdCuentaCobrar AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.FlagBorrador = 0 
														AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE)
														)

			SET @TotalSaldo  = ISNULL(@TotalCuentaCobrar,0) - ISNULL(@TotalMovimientoCuentaCobrar,0)

			RETURN ISNULL(@TotalSaldo,0)
END