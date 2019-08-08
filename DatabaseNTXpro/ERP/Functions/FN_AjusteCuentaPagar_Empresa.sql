CREATE FUNCTION ERP.FN_AjusteCuentaPagar_Empresa
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
					A.IdMoneda IdMonedaAjusteCP,
					A.TipoCambio TipoCambioAjusteCP,
					A.Total TotalAjusteCP
			FROM ERP.AjusteCuentaPagar A
			INNER JOIN ERP.CuentaPagar CP ON CP.ID = A.IdCuentaPagar
			WHERE CP.Flag = 1
			AND CP.IdEmpresa = @IdEmpresa
			AND CAST(A.Fecha AS DATE) <= CAST(@Fecha AS DATE)
			--AND CC.IdTipoComprobante NOT IN (8,21,55,60,183,178)
	)