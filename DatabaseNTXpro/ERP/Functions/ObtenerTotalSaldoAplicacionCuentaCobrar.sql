CREATE FUNCTION [ERP].[ObtenerTotalSaldoAplicacionCuentaCobrar](
@IdCuentaCobrar INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN
DECLARE @TotalCuentaCobrar DECIMAL(14,5);
DECLARE @TotalAplicacionCobrarDetalle DECIMAL(14,5);
DECLARE @TotalMovimientoCuentaCobrar DECIMAL(14,5); 
DECLARE @Saldo DECIMAL(14,5);

SET @TotalCuentaCobrar = (SELECT CC.Total FROM ERP.CuentaCobrar CC WHERE ID = @IdCuentaCobrar )

SET @TotalAplicacionCobrarDetalle = (SELECT SUM(AAPC.TotalAplicado)
											FROM ERP.AplicacionAnticipoCobrarDetalle AAPC
											INNER JOIN ERP.AplicacionAnticipoCobrar AAC
											ON AAC.ID = AAPC.IdAplicacionAnticipoCobrar
											INNER JOIN ERP.CuentaCobrar CC
											ON CC.ID = AAC.IdCuentaCobrar
											WHERE AAC.IdCuentaCobrar = @IdCuentaCobrar)


--SET @TotalMovimientoCuentaCobrar = (SELECT SUM(CASE WHEN MT.IdMoneda = 1 AND CC.IdMoneda = 1 THEN 
--MTD.Total
--WHEN MT.IdMoneda = 2 AND CC.IdMoneda = 1 THEN
--MTD.Total * MT.TipoCambio
--WHEN MT.IdMoneda = 2 AND CC.IdMoneda = 2 THEN
--MTD.Total
--WHEN MT.IdMoneda = 1 AND CC.IdMoneda = 2 THEN
--MTD.Total / MT.TipoCambio
--END
--)
--FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
--INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
--INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
--INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MDCC.IdCuentaCobrar
--WHERE CC.ID = @IdCuentaCobrar AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MTD.PagarCobrar = 'C')



SET @Saldo = ISNULL(@TotalCuentaCobrar,0) - ISNULL(@TotalAplicacionCobrarDetalle,0) /*- ISNULL(@TotalMovimientoCuentaCobrar,0)*/

RETURN ISNULL(@Saldo,0)
END
