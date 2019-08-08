CREATE FUNCTION [ERP].[ObtenerTotalSaldoAplicacionCuentaPagarDetalleMonedaOriginal](
@IdCuentaPagar INT
)
RETURNS DECIMAL(14,5)
AS 
BEGIN

		DECLARE @TotalCuentaPagar DECIMAL(14,5);
		DECLARE @TotalAplicacionPagarDetalle DECIMAL(14,5);
		DECLARE @TotalMovimientoCuentaPagar DECIMAL(14,5) 
		DECLARE @Saldo DECIMAL(14,5);

		SET @TotalCuentaPagar = (SELECT CP.Total FROM ERP.CuentaPagar CP WHERE ID = @IdCuentaPagar)

		SET @TotalAplicacionPagarDetalle = (SELECT SUM(IIF(AAP.IdMoneda = 2,IIF(CP.IdMoneda=2,AAPD.TotalAplicado,AAPD.TotalAplicado*AAP.TipoCambio),IIF(AAP.IdMoneda = 1,IIF(CP.IdMoneda =1,AAPD.TotalAplicado,ROUND((AAPD.TotalAplicado/AAP.TipoCambio),5)),AAPD.TotalAplicado)))
											FROM ERP.AplicacionAnticipoPagarDetalle AAPD
											INNER JOIN ERP.AplicacionAnticipoPagar AAP
											ON AAP.ID = AAPD.IdAplicacionAnticipo
											INNER JOIN ERP.CuentaPagar CP
											ON CP.ID = AAPD.IdCuentaPagar
											WHERE AAPD.IdCuentaPagar = @IdCuentaPagar)

		SET @TotalMovimientoCuentaPagar  = (SELECT	SUM(CASE	WHEN MT.IdMoneda = 1 AND CP.IdMoneda = 1 THEN 
																								MTD.Total
																WHEN MT.IdMoneda = 2 AND CP.IdMoneda = 1 THEN
																								MTD.Total * MT.TipoCambio
																WHEN MT.IdMoneda = 2 AND CP.IdMoneda = 2 THEN
																								MTD.Total
																WHEN MT.IdMoneda = 1 AND CP.IdMoneda = 2 THEN
																								MTD.Total / MT.TipoCambio
																			 END
																			)
																	FROM ERP.MovimientoTesoreriaDetalleCuentaPagar MDCP
																	INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCP.IdMovimientoTesoreriaDetalle
																	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
																	INNER JOIN ERP.CuentaPagar CP ON CP.ID = MDCP.IdCuentaPagar
																	WHERE CP.ID = @IdCuentaPagar AND MT.Flag = 1 AND MT.FlagBorrador = 0)

		SET @Saldo = ISNULL(@TotalCuentaPagar,0) - ISNULL(@TotalAplicacionPagarDetalle,0) - ISNULL(@TotalMovimientoCuentaPagar,0)

		RETURN ISNULL(@Saldo,0)
END
