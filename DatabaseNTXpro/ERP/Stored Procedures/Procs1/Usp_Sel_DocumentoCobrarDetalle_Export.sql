CREATE PROCEDURE [ERP].[Usp_Sel_DocumentoCobrarDetalle_Export]
@ListaCliente VARCHAR(MAX),
@ListaTipoComprobante VARCHAR(MAX),
@Fecha DATETIME,
@IdEmpresa INT,
@TipoFecha INT
AS
BEGIN
	SELECT CC.ID,
			CC.Serie,
			CASE 
				WHEN CC.IdMoneda = 1 THEN ISNULL(CC.Total, 0) * IIF(CC.IdDebeHaber = 2, -1, 1)
				ELSE 0 END AS TotalSoles,
			CASE 
				WHEN CC.IdMoneda = 2 THEN ISNULL(CC.Total, 0) * IIF(CC.IdDebeHaber = 2, -1, 1)
				ELSE 0 END AS TotalDolares,
			CASE 
				WHEN CC.IdMoneda = 1 THEN (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
				ELSE 0 END AS SaldoSoles,
			CASE 
				WHEN CC.IdMoneda = 2 THEN (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
				ELSE 0 END AS SaldoDolares,
			--CASE 
			--	WHEN CC.IdMoneda = 1 THEN (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
			--	ELSE ((CC.Total - ISNULL(TD.TotalPago, 0)) * CC.TipoCambio) * IIF(CC.IdDebeHaber = 2, -1, 1) END AS SaldoSoles,
			--CASE
			--	WHEN CC.IdMoneda = 2 THEN (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
			--	ELSE ((CC.Total - ISNULL(TD.TotalPago, 0)) / CC.TipoCambio) * IIF(CC.IdDebeHaber = 2, -1, 1) END AS SaldoDolares,
			CC.Numero,
			ENT.Nombre,
			CC.Fecha FechaEmision,
			CC.FechaVencimiento FechaVencimiento,
			MO.CodigoSunat,
			CC.Total,
			TC.Nombre TipoComprobante,
			CC.TipoCambio,
			T2.Abreviatura TipoDocumentoIdentidad,
			ETD.NumeroDocumento Ruc
	FROM ERP.CuentaCobrar CC
	LEFT JOIN ERP.FN_TotalPagosCuentaCobrar_Empresa(@IdEmpresa, @Fecha) TD
		ON TD.IdCuentaCobrar = CC.ID
	INNER JOIN Maestro.Moneda MO
		ON MO.ID = CC.IdMoneda
	INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CC.IdTipoComprobante
	INNER JOIN ERP.Entidad ENT
		ON ENT.ID = CC.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = ENT.ID
	INNER JOIN PLE.T2TipoDocumento T2 
		ON T2.ID = ETD.IdTipoDocumento
	INNER JOIN ERP.Cliente CLI
		ON CLI.IdEntidad = ENT.ID
	WHERE CC.Flag = 1 AND CC.IdEmpresa = @IdEmpresa
	AND CLI.ID IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaCliente,','))
	AND CC.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
	AND (
			(@TipoFecha = 1 AND CAST(CC.Fecha AS DATE) <= CAST(@Fecha AS DATE)) OR
			(@TipoFecha = 2 AND CAST(CC.FechaVencimiento AS DATE) <= CAST(@Fecha AS DATE))
		)
	AND CC.Total - ISNULL(TD.TotalPago, 0) > 0
END
