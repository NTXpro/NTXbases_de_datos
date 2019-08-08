CREATE FUNCTION [ERP].[ObtenerTotalSaldoAplicacionCuentaCobrarDetalleMonedaOriginal](
@IdCuentaCobrar	INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN
		DECLARE @TotalCuentaCobrar	DECIMAL(14,5);
		DECLARE @TotalAplicacionAnticipoCobrarDetalle DECIMAL(14,5);
		DECLARE @TotalMovimientoCuentaCobrar DECIMAL(14,5); 
		DECLARE @Saldo DECIMAL(14,5);

		SET @TotalCuentaCobrar = (SELECT CC.Total FROM ERP.CuentaCobrar CC WHERE ID = @IdCuentaCobrar)
		
		SET @TotalAplicacionAnticipoCobrarDetalle = (SELECT SUM(IIF(AAC.IdMoneda = 2,IIF(CC.IdMoneda=2,AACD.TotalAplicado,AACD.TotalAplicado*AAC.TipoCambio),IIF(AAC.IdMoneda = 1,IIF(CC.IdMoneda =1,AACD.TotalAplicado,ROUND((AACD.TotalAplicado/AAC.TipoCambio),5)),AACD.TotalAplicado)))
																FROM ERP.AplicacionAnticipoCobrarDetalle AACD
																INNER JOIN ERP.AplicacionAnticipoCobrar AAC
																ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
																INNER JOIN ERP.CuentaCobrar CC
																ON CC.ID = AACD.IdCuentaCobrar
																WHERE CC.ID = @IdCuentaCobrar)
		
		SET @TotalMovimientoCuentaCobrar = (SELECT	SUM(CASE	WHEN MT.IdMoneda = 1 AND CC.IdMoneda = 1 THEN 
																								MTD.Total
																WHEN MT.IdMoneda = 2 AND CC.IdMoneda = 1 THEN
																								MTD.Total * MT.TipoCambio
																WHEN MT.IdMoneda = 2 AND CC.IdMoneda = 2 THEN
																								MTD.Total
																WHEN MT.IdMoneda = 1 AND CC.IdMoneda = 2 THEN
																								MTD.Total / MT.TipoCambio
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
