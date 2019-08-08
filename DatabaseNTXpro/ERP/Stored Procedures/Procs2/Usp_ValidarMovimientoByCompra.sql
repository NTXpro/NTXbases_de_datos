CREATE PROC [ERP].[Usp_ValidarMovimientoByCompra] 
@IdCompra INT
AS
BEGIN

		DECLARE @COUNTMOVIMIENTO INT ;
		DECLARE @APLICACIONDETALLE INT ;
		DECLARE @APLICACIONCABECERA INT ;
		DECLARE @COUNTTOTAL INT;
		DECLARE @IdCuentaPagar INT = (SELECT IdCuentaPagar FROM ERP.CompraCuentaPagar CCP INNER JOIN ERP.CuentaPagar CP ON CCP.IdCuentaPagar = CP.ID
															 WHERE CCP.IdCompra = @IdCompra AND CP.Flag = 0)
		
	
		SET @COUNTMOVIMIENTO = (SELECT COUNT(MT.ID)
										FROM ERP.Compra CO
										INNER JOIN ERP.CompraCuentaPagar CCP
										ON CCP.IdCompra = CO.ID
										INNER JOIN ERP.CuentaPagar CP
										ON CP.ID = CCP.IdCuentaPagar
										INNER JOIN ERP.MovimientoTesoreriaDetalleCuentaPagar MDC
										ON MDC.IdCuentaPagar = CP.ID
										INNER JOIN ERP.MovimientoTesoreriaDetalle MD
										ON MD.ID =MDC.IdMovimientoTesoreriaDetalle
										INNER JOIN ERP.MovimientoTesoreria MT
										ON MT.ID = MD.IdMovimientoTesoreria
										WHERE CO.ID = @IdCompra AND MT.Flag = 1 AND MT.FlagBorrador = 0 )

		SET @APLICACIONCABECERA = (SELECT COUNT(AAP.ID)
											FROM ERP.AplicacionAnticipoPagar AAP
											INNER JOIN ERP.CuentaPagar CP
											ON CP.ID = AAP.IdCuentaPagar
											WHERE AAP.Flag = 1 AND CP.ID = @IdCuentaPagar)

		SET @APLICACIONDETALLE = (SELECT COUNT(AAD.ID)
									FROM ERP.AplicacionAnticipoPagarDetalle AAD 
									INNER JOIN ERP.CuentaPagar CP
									ON CP.ID = AAD.IdCuentaPagar
									WHERE CP.ID = @IdCuentaPagar)

		SET @COUNTTOTAL = ISNULL(@COUNTMOVIMIENTO,0) + ISNULL(@APLICACIONCABECERA,0) + ISNULL(@APLICACIONDETALLE,0)

		SELECT ISNULL(@COUNTTOTAL,0)
END
