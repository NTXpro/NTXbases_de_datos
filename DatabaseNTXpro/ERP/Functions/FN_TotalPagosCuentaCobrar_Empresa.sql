CREATE FUNCTION ERP.FN_TotalPagosCuentaCobrar_Empresa
(
	@IdEmpresa INT,
	@Fecha DATETIME
)
RETURNS TABLE
AS
	RETURN (
		SELECT SUM(TotalPago) TotalPago, IdCuentaCobrar
		FROM (
			SELECT SUM(CASE WHEN IdMonedaCC = 1
						THEN
							CASE
								WHEN IdMonedaMT = 1 THEN TotalMTD
								ELSE CAST(TotalMTD * TipoCambioMT AS DECIMAL(14, 2)) END
						ELSE  0
					END) + SUM(CASE WHEN IdMonedaCC = 2
							THEN
								CASE
									WHEN IdMonedaMT = 2 THEN TotalMTD
									ELSE CAST(TotalMTD / TipoCambioMT AS DECIMAL(14, 2)) END
							ELSE  0
						END) TotalPago,
				IdCuentaCobrar
			FROM ERP.FN_MTCuentaCobrar_Empresa(@IdEmpresa, @Fecha)
			GROUP BY IdCuentaCobrar

			UNION ALL

			SELECT SUM(CASE
							WHEN IdMonedaCC = 1
							THEN
								CASE
									WHEN IdMonedaAjusteCC = 1 THEN TotalAjusteCC
									ELSE CAST(TotalAjusteCC * TipoCambioAjusteCC AS DECIMAL(14, 2)) END
							ELSE 0
						END) + SUM(CASE
							WHEN IdMonedaCC = 2
							THEN
								CASE
									WHEN IdMonedaAjusteCC = 2 THEN TotalAjusteCC
									ELSE CAST(TotalAjusteCC / TipoCambioAjusteCC AS DECIMAL(14, 2)) END
							ELSE 0
						END) TotalPago,
					IdCuentaCobrar
			FROM ERP.FN_AjusteCuentaCobrar_Empresa(@IdEmpresa)
			GROUP BY IdCuentaCobrar

			UNION ALL

			SELECT SUM(CASE
						WHEN IdMonedaCC = 1 THEN
							CASE
								WHEN IdMonedaAACC = 1 THEN TotalAACC
								ELSE CAST(TotalAACC * TipoCambioAACC AS DECIMAL(14, 2)) END
						ELSE 0
					END) + SUM(CASE
							WHEN IdMonedaCC = 2 THEN
								CASE
									WHEN IdMonedaAACC = 2 THEN TotalAACC
									ELSE CAST(TotalAACC / TipoCambioAACC AS DECIMAL(14, 2)) END
							ELSE 0
						END) TotalPago,
					IdCuentaCobrar
			FROM ERP.FN_AplicacionAnticipoCobrar_Empresa(@IdEmpresa)
			GROUP BY IdCuentaCobrar) PAGOS_CC
	GROUP BY IdCuentaCobrar
)