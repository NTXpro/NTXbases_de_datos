CREATE FUNCTION [ERP].[SaldoTotalCuentaPagarDeSolesPorFecha](@IdCuentaPagar INT, @Fecha DATETIME) 
RETURNS DECIMAL(14,5)
AS
BEGIN

DECLARE @TotalCuentaPagar DECIMAL(14,5);
DECLARE @TotalMovimientoCuentaPagar DECIMAL(14,5);
DECLARE @TotalAplicacionAnticipo DECIMAL(14,5);
DECLARE @TotalAjuste DECIMAL(14,5);
DECLARE @TotalSaldo DECIMAL(14,5);

/*ID CUENTA PAGAR QUE VIENE DE UN ANTICIPO O DE UNA NOTA DE CRÉDITO*/
			
DECLARE @IdTipoComprobante TABLE (ID INT)

INSERT INTO @IdTipoComprobante SELECT ID FROM PLE.T10TipoComprobante WHERE ID IN (8,55,60,183,178,200)

DECLARE @IdTipoComprobanteCuentaPagar INT = (SELECT IdTipoComprobante FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar)

/******************************************/

/*Origen Anticipos*/

DECLARE @IdCuentaPagarOrigen INT = (SELECT ID FROM Maestro.CuentaPagarOrigen WHERE ID = 2);

/******************************************/

SET @TotalAjuste = (SELECT SUM(CASE
									WHEN A.IdMoneda = 1
										THEN A.Total
									WHEN A.IdMoneda = 2
										THEN ROUND((A.Total * A.TipoCambio),2)
								END)
						FROM ERP.AjusteCuentaPagar A
						WHERE A.IdCuentaPagar = @IdCuentaPagar AND CAST(A.Fecha AS DATE) <= CAST(@Fecha AS DATE))

SET @TotalCuentaPagar = (SELECT Total FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar)

SET @TotalMovimientoCuentaPagar = (SELECT SUM(CASE
													WHEN MT.IdMoneda = 1 AND CP.IdMoneda = 1
														THEN MTD.Total
													WHEN MT.IdMoneda = 2 AND CP.IdMoneda = 1
														THEN ROUND((MTD.Total * MT.TipoCambio),2)
												END)
										FROM ERP.MovimientoTesoreriaDetalleCuentaPagar MDCP
										INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCP.IdMovimientoTesoreriaDetalle
										INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
										INNER JOIN ERP.CuentaPagar CP ON CP.ID = MDCP.IdCuentaPagar
										WHERE CP.ID = @IdCuentaPagar AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE)
										/*AND CP.IdTipoComprobante NOT IN(178)*/)

--IF(@IdTipoComprobanteCuentaPagar IN (SELECT ID FROM @IdTipoComprobante))
--	BEGIN
--		IF(@IdCuentaPagarOrigen IN (SELECT IdCuentaPagarOrigen FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar))
--			BEGIN
--			SET @TotalAplicacionAnticipo	=	(SELECT SUM (AAPD.TotalAplicado)
--													FROM ERP.AplicacionAnticipoPagar AAP
--													INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
--													INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAP.IdCuentaPagar
--													WHERE CP.ID = @IdCuentaPagar AND CP.Flag = 1 AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE))
--			END
--		ELSE
--			BEGIN
--			SET @TotalAplicacionAnticipo	=	(SELECT SUM (AAPD.TotalAplicado)
--													FROM ERP.AplicacionAnticipoPagar AAP
--													INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
--													INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAP.IdCuentaPagar
--													WHERE CP.ID = @IdCuentaPagar AND CP.Flag = 1 AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE)
--													AND CP.IdTipoComprobante NOT IN (183))
--			END
--	END

IF(@IdTipoComprobanteCuentaPagar IN (SELECT ID FROM @IdTipoComprobante))
	BEGIN
		SET @TotalAplicacionAnticipo	=	(SELECT SUM (AAPD.TotalAplicado)
												FROM ERP.AplicacionAnticipoPagar AAP
												INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
												INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAP.IdCuentaPagar
												WHERE CP.ID = @IdCuentaPagar AND CP.Flag = 1 AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE)
												AND CP.IdTipoComprobante NOT IN (183))
	END
ELSE
	BEGIN
		SET @TotalAplicacionAnticipo	=	(SELECT SUM(CASE
															WHEN AAP.IdMoneda = 1 AND CP.IdMoneda = 1
																THEN AAPD.TotalAplicado
															WHEN AAP.IdMoneda = 2 AND CP.IdMoneda = 1
																THEN ROUND((AAPD.TotalAplicado * AAP.TipoCambio),2)
														END)
												FROM ERP.AplicacionAnticipoPagar AAP
												INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
												INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAPD.IdCuentaPagar
												WHERE CP.ID = @IdCuentaPagar AND CP.Flag = 1 AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE))
	END

SET @TotalSaldo  = ISNULL(@TotalCuentaPagar,0) - ISNULL(@TotalMovimientoCuentaPagar,0) - ISNULL(@TotalAplicacionAnticipo,0) - ISNULL(@TotalAjuste,0)

RETURN ISNULL(@TotalSaldo,0) 

END