CREATE FUNCTION [ERP].[ObtenerTotalSaldoAplicacionCuentaPagar](
@IdCuentaPagar INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN

		DECLARE @TotalCuentaPagar DECIMAL(14,5) ;
		DECLARE @TotalAplicacionPagarDetalle DECIMAL(14,5);
		DECLARE @TotalMovimientoCuentaPagar DECIMAL(14,5) 
		DECLARE @Saldo DECIMAL(14,5);
		
		
		SET @TotalCuentaPagar= (SELECT CP.Total FROM ERP.CuentaPagar CP WHERE ID = @IdCuentaPagar)


		SET @TotalAplicacionPagarDetalle = (SELECT SUM(AAPD.TotalAplicado)
													FROM ERP.AplicacionAnticipoPagarDetalle AAPD
													INNER JOIN ERP.AplicacionAnticipoPagar AAP 
													ON AAPD.IdAplicacionAnticipo = AAP.ID
													INNER JOIN ERP.CuentaPagar CP
													ON CP.ID = AAP.IdCuentaPagar
													WHERE AAP.IdCuentaPagar = @IdCuentaPagar)
		
		--SET @TotalMovimientoCuentaPagar  = (SELECT	SUM(CASE	WHEN MT.IdMoneda = 1 AND CP.IdMoneda = 1 THEN 
		--																						MTD.Total
		--														WHEN MT.IdMoneda = 2 AND CP.IdMoneda = 1 THEN
		--																						MTD.Total * MT.TipoCambio
		--														WHEN MT.IdMoneda = 2 AND CP.IdMoneda = 2 THEN
		--																						MTD.Total
		--														WHEN MT.IdMoneda = 1 AND CP.IdMoneda = 2 THEN
		--																						MTD.Total / MT.TipoCambio
		--																	 END
		--																	)
		--															FROM ERP.MovimientoTesoreriaDetalleCuentaPagar MDCP
		--															INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCP.IdMovimientoTesoreriaDetalle
		--															INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
		--															INNER JOIN ERP.CuentaPagar CP ON CP.ID = MDCP.IdCuentaPagar
		--															WHERE CP.ID = @IdCuentaPagar AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MTD.PagarCobrar = 'P')

		SET @Saldo = ISNULL(@TotalCuentaPagar,0)-ISNULL(@TotalAplicacionPagarDetalle,0) /*- ISNULL(@TotalMovimientoCuentaPagar,0)*/

		RETURN ISNULL(@Saldo,0)
END
