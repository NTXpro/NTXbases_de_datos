CREATE FUNCTION [ERP].[TotalAplicacionAjustePagarDeConvSolesPorFecha](@IdCuentaPagar INT, @Fecha DATETIME) 
			RETURNS DECIMAL(14,5)
			AS
			BEGIN

			DECLARE @TotalAplicacionAnticipo DECIMAL(14,5);
			DECLARE @TotalAjuste DECIMAL(14,5);

			/*ID CUENTA PAGAR QUE VIENE DE UN ANTICIPO O DE UNA NOTA DE CRÉDITO*/
			
			DECLARE @IdTipoComprobante TABLE (ID INT)

			INSERT INTO @IdTipoComprobante SELECT ID FROM PLE.T10TipoComprobante WHERE ID IN (8,55,60,183,178)

			DECLARE @IdTipoComprobanteCuentaPagar INT = (SELECT IdTipoComprobante FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar)

			SET @TotalAjuste = (SELECT SUM(CASE WHEN A.IdMoneda = 1 THEN
									A.Total
								WHEN A.IdMoneda = 2 THEN 
									ROUND((A.Total * A.TipoCambio),2)
								END)
								FROM ERP.AjusteCuentaPagar A
								WHERE A.IdCuentaPagar = @IdCuentaPagar AND CAST(A.Fecha AS DATE) <= CAST(@Fecha AS DATE))

			/******************************************/
			IF(@IdTipoComprobanteCuentaPagar IN (SELECT ID FROM @IdTipoComprobante))
				BEGIN 
				SET @TotalAplicacionAnticipo	=  (SELECT SUM (AAPD.TotalAplicado)
																FROM ERP.AplicacionAnticipoPagar AAP
																INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
																INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAP.IdCuentaPagar
																WHERE CP.ID = @IdCuentaPagar AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE))
				END
			ELSE
				BEGIN
				SET @TotalAplicacionAnticipo	= (SELECT SUM(CASE WHEN AAP.IdMoneda = 1 THEN
																			AAPD.TotalAplicado
															   WHEN AAP.IdMoneda = 2 THEN 
																			ROUND((AAPD.TotalAplicado * AAP.TipoCambio),2)
																		END 
																			)
																FROM ERP.AplicacionAnticipoPagar AAP
																INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
																INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAPD.IdCuentaPagar
																WHERE CP.ID = @IdCuentaPagar AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE))
			
				END 

				 DECLARE @Total DECIMAL(14,5) = ISNULL(@TotalAplicacionAnticipo,0) + ISNULL(@TotalAjuste,0);
			 RETURN @Total;
END