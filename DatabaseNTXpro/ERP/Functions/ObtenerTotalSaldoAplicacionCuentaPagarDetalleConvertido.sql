CREATE FUNCTION [ERP].[ObtenerTotalSaldoAplicacionCuentaPagarDetalleConvertido](
@IdCuentaPagarCabecera INT,
@IdCuentaPagar INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN
		DECLARE @TotalCuentaPagar DECIMAL(14,5);
		DECLARE @TotalAplicacionPagarDetalle DECIMAL(14,5);
		DECLARE @TotalMovimientoCuentaPagar  DECIMAL(14,5);
		DECLARE @Saldo DECIMAL(14,5);

		DECLARE @IdMoneda INT = (SELECT IdMoneda FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagarCabecera)

		DECLARE @FechaRecepcion DATETIME = (SELECT FechaRecepcion FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagarCabecera)

		DECLARE @TotalCambio DECIMAL(14,5) = (SELECT ERP.ObtenerTipoCambioVenta_By_Sistema_Fecha('SUNAT',(@FechaRecepcion)));

		SET @TotalCuentaPagar = (SELECT IIF(@IdMoneda = 2,IIF(CP.IdMoneda=2,CP.Total,CP.Total/@TotalCambio),IIF(@IdMoneda = 1,IIF(CP.IdMoneda =1,CP.Total,ROUND((CP.Total*@TotalCambio),5)),CP.Total)) FROM ERP.CuentaPagar CP WHERE ID = @IdCuentaPagar)

		SET @TotalAplicacionPagarDetalle = (SELECT SUM(CASE WHEN @IdMoneda = AAP.IdMoneda THEN
																AAPD.TotalAplicado
															WHEN AAP.IdMoneda = 1  THEN
																AAPD.TotalAplicado / @TotalCambio
															WHEN AAP.IdMoneda = 2 THEN
																AAPD.TotalAplicado * @TotalCambio												
															END)
													FROM ERP.AplicacionAnticipoPagarDetalle AAPD
													INNER JOIN ERP.AplicacionAnticipoPagar AAP
													ON AAP.ID = AAPD.IdAplicacionAnticipo
													INNER JOIN ERP.CuentaPagar CP
													ON CP.ID = AAPD.IdCuentaPagar
													WHERE AAPD.IdCuentaPagar = @IdCuentaPagar)

		SET @TotalMovimientoCuentaPagar  = (SELECT	SUM(CASE	WHEN MT.IdMoneda = 1 AND CP.IdMoneda = 1 THEN 
																					CASE WHEN @IdMoneda = 1 THEN
																								MTD.Total
																					ELSE
																								MTD.Total / @TotalCambio
																					END
																WHEN MT.IdMoneda = 2 AND CP.IdMoneda = 1 THEN
																					CASE WHEN @IdMoneda = 1 THEN
																								MTD.Total * MT.TipoCambio
																					ELSE
																								(MTD.Total * MT.TipoCambio)/ @TotalCambio
																					END



																WHEN MT.IdMoneda = 2 AND CP.IdMoneda = 2 THEN
																					CASE WHEN @IdMoneda = 2 THEN
																								MTD.Total
																					ELSE
																								MTD.Total * @TotalCambio
																					END
																WHEN MT.IdMoneda = 1 AND CP.IdMoneda = 2 THEN
																					CASE WHEN @IdMoneda = 2 THEN
																								MTD.Total / MT.TipoCambio
																					ELSE
																								(MTD.Total / MT.TipoCambio)* @TotalCambio
																					END
																					
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
