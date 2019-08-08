CREATE PROC [ERP].[Usp_ValidarMovimientoBySaldoInicial] --4
@IdSaldo INT
AS
BEGIN

			SELECT COUNT (MT.ID)
			FROM ERP.SaldoInicial SI
			INNER JOIN ERP.SaldoInicialCuentaPagar SCP
			ON SCP.IdSaldoInicial = SI.ID
			INNER JOIN ERP.CuentaPagar CP
			ON CP.ID = SCP.IdSaldoInicial
			INNER JOIN ERP.MovimientoTesoreriaDetalleCuentaPagar MDC
			ON MDC.IdCuentaPagar = SCP.IdCuentaPagar
			INNER JOIN ERP.MovimientoTesoreriaDetalle MD
			ON MD.ID =MDC.IdMovimientoTesoreriaDetalle
			INNER JOIN ERP.MovimientoTesoreria MT
			ON MT.ID = MD.IdMovimientoTesoreria
			WHERE SI.ID = @IdSaldo AND MT.Flag = 1 AND MT.FlagBorrador = 0 
END
