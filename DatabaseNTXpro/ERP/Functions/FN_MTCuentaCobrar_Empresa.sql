CREATE FUNCTION ERP.FN_MTCuentaCobrar_Empresa
(
	@IdEmpresa INT,
	@Fecha DATETIME
)
RETURNS TABLE
AS
	RETURN (
			SELECT	CC.IdEntidad IdEntidadCC,
					CC.Fecha FechaCC,
					CC.FechaVencimiento FechaVencimientoCC,
					CC.IdTipoComprobante IdTipoComprobanteCC,
					CC.ID IdCuentaCobrar,
					CC.IdMoneda IdMonedaCC, 
					MT.IdMoneda IdMonedaMT,
					MT.TipoCambio TipoCambioMT,
					MTD.Total TotalMTD
			FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
			INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MDCC.IdCuentaCobrar
			INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
			INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
			WHERE CC.Flag = 1
			AND CC.IdEmpresa = @IdEmpresa
			AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE)
			--AND CC.IdTipoComprobante NOT IN (8,21,55,60,183,178)
			AND MT.FlagBorrador = 0
			AND MT.Flag = 1
	)