CREATE FUNCTION [ERP].[SaldoTotalCuentaCobrarDeSoles] (@IdCuentaCobrar INT)
RETURNS DECIMAL(14,5)
AS
BEGIN
			DECLARE @TotalCuentaCobrar DECIMAL(14,5);
			DECLARE @TotalMovimientoCuentaCobrar DECIMAL(14,5);
			DECLARE @TotalAplicacionAnticipo DECIMAL(14,5);
			DECLARE @TotalAjuste DECIMAL(14,5);
			DECLARE @TotalSaldo DECIMAL(14,5);

			/*ID CUENTA PAGAR QUE VIENE DE UN ANTICIPO O DE UNA NOTA DE CRÉDITO*/

			DECLARE @IdTipoComprobante TABLE (ID INT)

			INSERT INTO @IdTipoComprobante SELECT ID FROM PLE.T10TipoComprobante WHERE ID IN (8,21,55,60,183,178)

			DECLARE @IdTipoComprobanteCuentaCobrar INT = (SELECT IdTipoComprobante FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrar)

			/******************************************/

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
														WHERE CC.ID = @IdCuentaCobrar AND MT.Flag = 1 AND MT.FlagBorrador = 0 
														/*AND CC.IdTipoComprobante NOT IN (183)*/
														)
			
			SET @TotalAjuste = (SELECT (CASE WHEN A.IdMoneda = 1  THEN
											A.Total
										WHEN A.IdMoneda = 2 THEN
											ROUND((A.Total * A.TipoCambio),2)
										END) 
								FROM ERP.AjusteCuentaCobrar A
								WHERE A.IdCuentaCobrar = @IdCuentaCobrar)

			IF(@IdTipoComprobanteCuentaCobrar IN (SELECT ID FROM @IdTipoComprobante))
				BEGIN
				SET @TotalAplicacionAnticipo = (SELECT SUM (AACD.TotalAplicado)
															FROM ERP.AplicacionAnticipoCobrar AAC
															INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AACD ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
															INNER JOIN ERP.CuentaCobrar	CC ON CC.ID = AAC.IdCuentaCobrar
															WHERE CC.ID = @IdCuentaCobrar)
				END
			ELSE
				BEGIN
				SET @TotalAplicacionAnticipo = (SELECT SUM (CASE WHEN AAC.IdMoneda = 1 AND CC.IdMoneda = 1 THEN
																		AACD.TotalAplicado
															WHEN AAC.IdMoneda = 2 AND CC.IdMoneda = 1 THEN
																		ROUND((AACD.TotalAplicado * AAC.TipoCambio),2)
																		END
																		)
															FROM ERP.AplicacionAnticipoCobrar AAC
															INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AACD ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
															INNER JOIN ERP.CuentaCobrar CC ON CC.ID = AACD.IdCuentaCobrar
															WHERE CC.ID = @IdCuentaCobrar)
				END


			SET @TotalSaldo  = ISNULL(@TotalCuentaCobrar,0) - ISNULL(@TotalMovimientoCuentaCobrar,0) - ISNULL(@TotalAplicacionAnticipo,0) - ISNULL(@TotalAjuste,0)

			RETURN ISNULL(@TotalSaldo,0)
END