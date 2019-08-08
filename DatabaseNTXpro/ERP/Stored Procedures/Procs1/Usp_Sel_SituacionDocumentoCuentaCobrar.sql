CREATE PROCEDURE [ERP].[Usp_Sel_SituacionDocumentoCuentaCobrar]
@TipoFecha INT,
@EstadoDocumento INT,
@Fecha DATETIME,
@FechaHasta datetime,
@IdCliente INT,
@IdEmpresa INT
AS
BEGIN

	DECLARE @IdEntidad INT = (SELECT IdEntidad FROM ERP.Cliente WHERE ID = @IdCliente)

	DECLARE @Fecha2 DATETIME = (SELECT
										CASE
											WHEN @TipoFecha = 1 THEN @Fecha
											WHEN @TipoFecha = 2 THEN @FechaHasta
										END)

	SELECT	ST.Cliente,
			ST.ID,
			ST.ID,
			ST.FechaEmision,
			ST.IdMoneda,
			ST.FechaVencimiento,
			ST.TipoComprobante,
			ST.Serie,
			ST.Documento,
			ST.Total,
			ST.TipoCambio,
			ST.Moneda,
			ST.Origen,
			ST.IdEntidad,
			ST.Flag,
			ST.FlagCancelo,
			ST.IdTipoComprobante,
			ST.IdEmpresa,
			ST.Saldo,
			ST.Debe,
			ST.Haber
	FROM
	(SELECT	ENT.Nombre											Cliente,
			CC.ID												ID,
			CC.Fecha											FechaEmision,
			CC.IdMoneda											IdMoneda,
			CC.FechaVencimiento									FechaVencimiento,
			TC.Nombre											TipoComprobante,
			CC.Serie											Serie,
			CC.Numero											Documento,
			CC.Total											Total,
			CC.TipoCambio										TipoCambio,
			MO.CodigoSunat										Moneda,
			CCO.Nombre											Origen,
			CC.IdEntidad										IdEntidad,
			CC.Flag												Flag,
			CC.FlagCancelo										FlagCancelo,
			CC.IdTipoComprobante								IdTipoComprobante,
			CC.IdEmpresa										IdEmpresa,
			(CASE
				WHEN CC.IdMoneda = 1 AND CC.IdDebeHaber = 1 THEN
						(SELECT(ERP.SaldoTotalCuentaCobrarDeSolesPorFecha(CC.ID, @Fecha2)))
				WHEN CC.IdMoneda = 1 AND CC.IdDebeHaber = 2 THEN
						(SELECT(ERP.SaldoTotalCuentaCobrarDeSolesPorFecha(CC.ID, @Fecha2))) * (-1)
				WHEN CC.IdMoneda = 2 AND CC.IdDebeHaber = 1 THEN
						(SELECT(ERP.SaldoTotalCuentaCobrarDeDolaresPorFecha(CC.ID, @Fecha2)))
				WHEN CC.IdMoneda = 2 AND CC.IdDebeHaber = 2 THEN
						(SELECT(ERP.SaldoTotalCuentaCobrarDeDolaresPorFecha(CC.ID, @Fecha2))) * (-1)
					END) AS Saldo,
			(CASE
				WHEN CC.IdDebeHaber = 1 AND CC.IdMoneda = 1 THEN CC.Total
				WHEN CC.IdDebeHaber = 1 AND CC.IdMoneda = 2 THEN CC.Total
				END) AS Debe,
			(CASE
				WHEN CC.IdDebeHaber = 2 AND CC.IdMoneda = 1 THEN CC.Total
				WHEN CC.IdDebeHaber = 2 AND CC.IdMoneda = 2 THEN CC.Total
				END) AS Haber
		FROM ERP.CuentaCobrar CC
		INNER JOIN ERP.Entidad ENT ON ENT.ID = CC.IdEntidad
		INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CC.IdTipoComprobante
		INNER JOIN Maestro.Moneda MO ON MO.ID = CC.IdMoneda
		INNER JOIN Maestro.CuentaCobrarOrigen CCO ON CCO.ID = CC.IdCuentaCobrarOrigen
		INNER JOIN Maestro.DebeHaber DH ON DH.ID = CC.IdDebeHaber) AS ST
		WHERE (
				(@TipoFecha = 1 AND CAST(ST.FechaEmision AS DATE) <= CAST(@Fecha2 AS DATE)) OR
				(@TipoFecha = 2 AND CAST(ST.FechaVencimiento AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@Fecha2 AS DATE))
			   )
		AND ST.IdEntidad = @IdEntidad
		AND ST.Flag = 1  AND ST.IdEmpresa = @IdEmpresa
		AND ((@EstadoDocumento = -1) OR (@EstadoDocumento = 0 AND ST.Saldo != 0) OR (@EstadoDocumento = 1 AND ST.Saldo = 0))
		ORDER BY ST.IdTipoComprobante DESC
END