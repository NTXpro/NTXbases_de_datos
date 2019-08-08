
CREATE FUNCTION ERP.FN_TotalPagosCuentaPagar_Empresa
(
	@IdEmpresa INT,
	@Fecha DATETIME
)
RETURNS TABLE
AS
	RETURN (
		SELECT SUM(TotalPago) TotalPago, IdCuentaPagar
		FROM (
			SELECT SUM(CASE WHEN IdMonedaCP = 1
						THEN
							CASE
								WHEN IdMonedaMT = 1 THEN TotalMTD
								ELSE CAST(TotalMTD * TipoCambioMT AS DECIMAL(14, 2)) END
						ELSE  0
					END) + SUM(CASE WHEN IdMonedaCP = 2
							THEN
								CASE
									WHEN IdMonedaMT = 2 THEN TotalMTD
									ELSE CAST(TotalMTD / TipoCambioMT AS DECIMAL(14, 2)) END
							ELSE  0
						END) TotalPago,
				IdCuentaPagar
			FROM ERP.FN_MTCuentaPagar_Empresa(@IdEmpresa, @Fecha)
			GROUP BY IdCuentaPagar

			UNION ALL

			SELECT SUM(CASE
							WHEN IdMonedaCP = 1
							THEN
								CASE
									WHEN IdMonedaAjusteCP = 1 THEN TotalAjusteCP
									ELSE CAST(TotalAjusteCP * TipoCambioAjusteCP AS DECIMAL(14, 2)) END
							ELSE 0
						END) + SUM(CASE
							WHEN IdMonedaCP = 2
							THEN
								CASE
									WHEN IdMonedaAjusteCP = 2 THEN TotalAjusteCP
									ELSE CAST(TotalAjusteCP / TipoCambioAjusteCP AS DECIMAL(14, 2)) END
							ELSE 0
						END) TotalPago,
					IdCuentaPagar
			FROM ERP.FN_AjusteCuentaPagar_Empresa(@IdEmpresa, @Fecha)
			GROUP BY IdCuentaPagar

			UNION ALL

			SELECT SUM(CASE
						WHEN IdMonedaCP = 1 THEN
							CASE
								WHEN IdMonedaAACP = 1 THEN TotalAACP
								ELSE CAST(TotalAACP * TipoCambioAACP AS DECIMAL(14, 2)) END
						ELSE 0
					END) + SUM(CASE
							WHEN IdMonedaCP = 2 THEN
								CASE
									WHEN IdMonedaAACP = 2 THEN TotalAACP
									ELSE CAST(TotalAACP / TipoCambioAACP AS DECIMAL(14, 2)) END
							ELSE 0
						END) TotalPago,
					IdCuentaPagar
			FROM ERP.FN_AplicacionAnticipoPagar_Empresa(@IdEmpresa, @Fecha)
			GROUP BY IdCuentaPagar) PAGOS_CC
	GROUP BY IdCuentaPagar
)