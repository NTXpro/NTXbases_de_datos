CREATE FUNCTION ERP.FN_AplicacionAnticipoPagar_Empresa
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
				AAP.IdMoneda IdMonedaAACP,
				AAP.TipoCambio TipoCambioAACP,				
				AACD.TotalAplicado TotalAACP
		FROM ERP.AplicacionAnticipoPagar AAP
		INNER JOIN ERP.AplicacionAnticipoPagarDetalle AACD ON AAP.ID = AACD.IdAplicacionAnticipo
		INNER JOIN ERP.CuentaPagar CP ON CP.ID = AACD.IdCuentaPagar
		WHERE CP.Flag = 1
		AND CP.IdEmpresa = @IdEmpresa
		AND AAP.Flag = 1
		AND CAST(AAP.Fecha AS DATE) <= CAST(@Fecha AS DATE)

		UNION ALL

		SELECT	CP.IdEntidad IdEntidadCP,
				CP.Fecha FechaCP,
				CP.FechaVencimiento FechaVencimientoCP,
				CP.IdTipoComprobante IdTipoComprobanteCP,
				CP.ID IdCuentaPagar,
				CP.IdMoneda IdMonedaCP,
				AAP.IdMoneda IdMonedaAACP,
				AAP.TipoCambio TipoCambioAACP,
				AACD.TotalAplicado TotalAACP
		FROM ERP.AplicacionAnticipoPagar AAP
		INNER JOIN ERP.AplicacionAnticipoPagarDetalle AACD ON AAP.ID = AACD.IdAplicacionAnticipo
		INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAP.IdCuentaPagar
		WHERE CP.Flag = 1
		AND CP.IdTipoComprobante NOT IN (183)
		AND CP.IdEmpresa = @IdEmpresa
		AND AAP.Flag = 1
		AND CAST(AACD.Fecha AS DATE) <= CAST(@Fecha AS DATE)
	)