CREATE FUNCTION ERP.FN_AplicacionAnticipoCobrar_Empresa
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
				AAC.IdMoneda IdMonedaAACC,
				AAC.TipoCambio TipoCambioAACC,				
				AACD.TotalAplicado TotalAACC
		FROM ERP.AplicacionAnticipoCobrar AAC
		INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AACD ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
		INNER JOIN ERP.CuentaCobrar	CC ON CC.ID = AACD.IdCuentaCobrar
		WHERE CC.Flag = 1
		AND CC.IdEmpresa = @IdEmpresa		
		AND AAC.Flag = 1

		UNION ALL

		SELECT	CC.IdEntidad IdEntidadCC,
				CC.Fecha FechaCC,
				CC.FechaVencimiento FechaVencimientoCC,
				CC.IdTipoComprobante IdTipoComprobanteCC,
				CC.ID IdCuentaCobrar,
				CC.IdMoneda IdMonedaCC,
				AAC.IdMoneda IdMonedaAACC,
				AAC.TipoCambio TipoCambioAACC,				
				AACD.TotalAplicado TotalAACC
		FROM ERP.AplicacionAnticipoCobrar AAC
		INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AACD ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
		INNER JOIN ERP.CuentaCobrar	CC ON CC.ID = AAC.IdCuentaCobrar		
		WHERE CC.Flag = 1
		AND CC.IdEmpresa = @IdEmpresa
		AND AAC.Flag = 1
	)