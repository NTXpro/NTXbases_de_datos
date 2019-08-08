CREATE FUNCTION [ERP].[ObtenerTotalSaldoAplicacionCuentaCobrarDetalleConvertido](
@IdCuentaCobrarCabecera INT,
@IdCuentaCobrar	INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN
	DECLARE @TotalCuentaCobrar DECIMAL(14,5);
	DECLARE @TotalAplicacionAnticipoCobrarDetalle DECIMAL(14,5);
	DECLARE @TotalMovimientoCuentaCobrar  DECIMAL(14,5);
	DECLARE @Saldo DECIMAL(14,5);

	DECLARE @IdMoneda INT = (SELECT IdMoneda FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrarCabecera)

	DECLARE @TotalCambio DECIMAL(14,5) = (SELECT TipoCambio FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrarCabecera)

	SET @TotalCuentaCobrar = (SELECT IIF(@IdMoneda = 2,IIF(CC.IdMoneda = 2,CC.Total,CC.Total/@TotalCambio),IIF(@IdMoneda = 1,IIF(CC.IdMoneda = 1, CC.Total , ROUND((CC.Total * @TotalCambio),5)),CC.Total))FROM ERP.CuentaCobrar CC WHERE ID = @IdCuentaCobrar)
	
	SET @TotalAplicacionAnticipoCobrarDetalle = (SELECT SUM(CASE WHEN @IdMoneda = AAC.IdMoneda THEN
																		AACD.TotalAplicado
																 WHEN AAC.IdMoneda = 1  THEN
																 	AACD.TotalAplicado / @TotalCambio
																 WHEN AAC.IdMoneda = 2 THEN
																 	AACD.TotalAplicado * @TotalCambio		
																 END)
													FROM ERP.AplicacionAnticipoCobrarDetalle AACD
													INNER JOIN ERP.AplicacionAnticipoCobrar AAC
													ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
													INNER JOIN ERP.CuentaCobrar CC
													ON CC.ID = AACD.IdCuentaCobrar
													WHERE AACD.IdCuentaCobrar = @IdCuentaCobrar)
	SET @TotalMovimientoCuentaCobrar  = (SELECT	SUM(CASE	WHEN MT.IdMoneda = 1 AND CC.IdMoneda = 1 THEN 
																					CASE WHEN @IdMoneda = 1 THEN
																								MTD.Total
																					ELSE
																								MTD.Total / @TotalCambio
																					END
																WHEN MT.IdMoneda = 2 AND CC.IdMoneda = 1 THEN
																					CASE WHEN @IdMoneda = 1 THEN
																								MTD.Total * MT.TipoCambio
																					ELSE
																								(MTD.Total * MT.TipoCambio)/ @TotalCambio
																					END



																WHEN MT.IdMoneda = 2 AND CC.IdMoneda = 2 THEN
																					CASE WHEN @IdMoneda = 2 THEN
																								MTD.Total
																					ELSE
																								MTD.Total * @TotalCambio
																					END
																WHEN MT.IdMoneda = 1 AND CC.IdMoneda = 2 THEN
																					CASE WHEN @IdMoneda = 2 THEN
																								MTD.Total / MT.TipoCambio
																					ELSE
																								(MTD.Total / MT.TipoCambio)* @TotalCambio
																					END
																					
																			 END
																			)
																	FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
																	INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
																	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
																	INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MDCC.IdCuentaCobrar
																	WHERE CC.ID = @IdCuentaCobrar AND MT.Flag = 1 AND MT.FlagBorrador = 0)


	SET @Saldo = ISNULL(@TotalCuentaCobrar,0) - ISNULL(@TotalAplicacionAnticipoCobrarDetalle,0) - ISNULL(@TotalMovimientoCuentaCobrar,0)

	RETURN ISNULL(@Saldo,0)
END
