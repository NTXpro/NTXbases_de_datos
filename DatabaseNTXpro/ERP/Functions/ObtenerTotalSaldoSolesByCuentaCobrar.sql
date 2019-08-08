CREATE FUNCTION ERP.ObtenerTotalSaldoSolesByCuentaCobrar(
@IdCuentaCobrar INT
)
RETURNS DECIMAL(14,5)
BEGIN

		DECLARE @Total DECIMAL(14,5);
		DECLARE @TotalMovimientoCuentaCobrarSoles DECIMAL(14,5);
		DECLARE @TotalCuentaCobrarSoles DECIMAL(14,5);

		SET @TotalCuentaCobrarSoles = (SELECT SUM(IIF(CC.IdMoneda = 1 ,CC.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))
										FROM ERP.CuentaCobrar CC
										WHERE CC.Flag = 1 AND CC.ID = @IdCuentaCobrar)
		SET @TotalMovimientoCuentaCobrarSoles = (SELECT SUM(IIF(CC.IdMoneda = 1 ,MTD.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))
													FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
													INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MDCC.IdCuentaCobrar
													INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
													INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
													INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
													WHERE MDCC.IdCuentaCobrar = @IdCuentaCobrar 
													AND MT.Flag = 1 AND MT.FlagBorrador = 0 
													AND MTD.IdDebeHaber = 2)

		SET @Total = ISNULL(@TotalCuentaCobrarSoles,0) - ISNULL(@TotalMovimientoCuentaCobrarSoles,0)

		RETURN ISNULL(@Total,0)
END
