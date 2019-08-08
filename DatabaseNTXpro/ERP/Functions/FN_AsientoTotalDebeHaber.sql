CREATE FUNCTION ERP.FN_AsientoTotalDebeHaber
(
	@IdEmpresa INT
)
RETURNS TABLE
AS
	RETURN (
	SELECT AI.ID IdAsiento,
		CAST(ISNULL(SUM(CASE 
						WHEN AD.IdDebeHaber = 1 AND AI.IdMoneda = 2 THEN AD.ImporteDolares * AI.TipoCambio 
						WHEN AD.IdDebeHaber = 1 AND AI.IdMoneda = 1 THEN AD.ImporteSoles
						END), 0) AS DECIMAL(14,2))
		AS TotalDebeSoles,
		CAST(ISNULL(SUM(CASE
						WHEN AD.IdDebeHaber = 2 AND AI.IdMoneda = 2 THEN AD.ImporteDolares * AI.TipoCambio
						WHEN AD.IdDebeHaber = 2 AND AI.IdMoneda = 1 THEN AD.ImporteSoles
						END), 0) AS DECIMAL(14,2))
		AS TotalHaberSoles,
		CAST(ISNULL(SUM(CASE
						WHEN AD.IdDebeHaber = 2 AND AI.IdMoneda = 2 THEN AD.ImporteDolares
						WHEN AD.IdDebeHaber = 2 AND AI.IdMoneda = 1 THEN AD.ImporteSoles
						END), 0) AS DECIMAL(14,2))
		AS TotalDebe,
		CAST(ISNULL(SUM(CASE
						WHEN AD.IdDebeHaber = 2 AND AI.IdMoneda = 2 THEN AD.ImporteDolares
						WHEN AD.IdDebeHaber = 2 AND AI.IdMoneda = 1 THEN AD.ImporteSoles
						END), 0) AS DECIMAL(14,2))
		AS TotalHaber,
		(CASE 
			WHEN SUM(CASE WHEN IdPlanCuenta IS NULL THEN 1 ELSE 0 END) >= 1 THEN 1
			ELSE 0 
		END) AS AsientoIncompleto
	FROM [ERP].[Asiento] AI
	INNER JOIN [ERP].[AsientoDetalle] AD ON AI.ID = AD.IdAsiento
	WHERE AI.Flag = 1 AND
	AI.FlagBorrador = 0 AND
	AI.IdEmpresa = @IdEmpresa					
	GROUP BY AI.ID
	)