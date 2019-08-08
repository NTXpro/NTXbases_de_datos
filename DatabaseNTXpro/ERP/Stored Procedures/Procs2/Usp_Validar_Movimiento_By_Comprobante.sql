CREATE PROC [ERP].[Usp_Validar_Movimiento_By_Comprobante] 
@IdComprobante INT
AS
BEGIN
		DECLARE @RESULT BIT 
		DECLARE @COUNTMOVIMIENTO INT = (SELECT COUNT(MT.ID)
											FROM ERP.Comprobante CO
											INNER JOIN ERP.ComprobanteCuentaCobrar CCC
											ON CCC.IdComprobante = CO.ID
											INNER JOIN ERP.CuentaCobrar CC
											ON CC.ID = CCC.IdCuentaCobrar
											INNER JOIN ERP.MovimientoTesoreriaDetalleCuentaCobrar MDC
											ON MDC.IdCuentaCobrar = CC.ID
											INNER JOIN ERP.MovimientoTesoreriaDetalle MD
											ON MD.ID = MDC.IdMovimientoTesoreriaDetalle
											INNER JOIN ERP.MovimientoTesoreria MT
											ON MT.ID = MD.IdMovimientoTesoreria
											WHERE CO.ID = @IdComprobante  AND MT.Flag = 1 AND MT.FlagBorrador = 0)



		IF(@COUNTMOVIMIENTO > 0 )
			SET 	@RESULT = CAST(1 AS BIT) 
		ELSE
			SET 	@RESULT = CAST(0 AS BIT) 	
				

		SELECT CAST(@RESULT AS BIT)

END