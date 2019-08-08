CREATE FUNCTION ERP.FN_AjusteCuentaCobrar_Empresa
(
	@IdEmpresa INT
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
					A.IdMoneda IdMonedaAjusteCC, 
					A.TipoCambio TipoCambioAjusteCC, 
					A.Total TotalAjusteCC
			FROM ERP.AjusteCuentaCobrar A
			INNER JOIN ERP.CuentaCobrar CC ON CC.ID = A.IdCuentaCobrar
			WHERE CC.Flag = 1				
			AND CC.IdEmpresa = @IdEmpresa
			--AND CC.IdTipoComprobante NOT IN (8,21,55,60,183,178)
	)