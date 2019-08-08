CREATE FUNCTION ERP.FN_MTCuentaPagar_Empresa
(
	@IdEmpresa INT,
	@Fecha DATETIME
)
RETURNS TABLE
AS
	RETURN (
			SELECT	CP.IdEntidad IdEntidadCP,
					CP.Fecha FechaCP,
					CP.FechaVencimiento FechaVencimientoCP,
					CP.IdTipoComprobante IdTipoComprobanteCP,
					CP.ID IdCuentaPagar,
					CP.IdMoneda IdMonedaCP, 
					MT.IdMoneda IdMonedaMT,
					MT.TipoCambio TipoCambioMT,
					MTD.Total TotalMTD
			FROM ERP.MovimientoTesoreriaDetalleCuentaPagar MDCP
			INNER JOIN ERP.CuentaPagar CP ON CP.ID = MDCP.IdCuentaPagar
			INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCP.IdMovimientoTesoreriaDetalle
			INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
			WHERE CP.Flag = 1
			AND CP.IdEmpresa = @IdEmpresa
			AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE)
			--AND CP.IdTipoComprobante NOT IN (8,21,55,60,183,178)
			AND MT.FlagBorrador = 0
			AND MT.Flag = 1
)