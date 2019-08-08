CREATE PROC ERP.Usp_Sel_DocumentoCobrarDetalleRetencion_Export_2
@ListaCliente VARCHAR(MAX),
@ListaTipoComprobante VARCHAR(MAX),
@FechaDesde DATETIME,
@FechaHasta DATETIME,
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
				WHEN CC.IdMoneda = 1
					THEN 
						CASE
							WHEN CLI.AgenteRetencion = 1 AND ISNULL(CC.Total, 0) >= 700 THEN (ISNULL(CC.Total, 0) - (ISNULL(CC.Total, 0) * 0.03)) * IIF(CC.IdDebeHaber = 2, -1, 1)
							ELSE (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
						END
				END AS SaldoSoles,
			CASE 
				WHEN CC.IdMoneda = 2
					THEN 
						CASE
							WHEN CLI.AgenteRetencion = 1 AND ISNULL(CC.Total, 0) >= 700 THEN (ISNULL(CC.Total, 0) - (ISNULL(CC.Total, 0) * 0.03)) * IIF(CC.IdDebeHaber = 2, -1, 1)
							ELSE (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
						END
				END AS SaldoDolares,
			--CASE 
			--	WHEN CC.IdMoneda = 2 THEN (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
			--	ELSE 0 END AS SaldoDolares,
			CASE
				WHEN CC.IdMoneda = 1 AND CLI.AgenteRetencion = 1 AND ISNULL(CC.Total, 0) >= 700 THEN CAST((ISNULL(CC.Total, 0) * 0.03) * IIF(CC.IdDebeHaber = 2, -1, 1) AS Decimal(14,2))
				WHEN CC.IdMoneda = 2 AND CLI.AgenteRetencion = 1 AND ISNULL(CC.Total, 0) >= 700 THEN CAST((ISNULL(CC.Total, 0) * 0.03) * IIF(CC.IdDebeHaber = 2, -1, 1) AS Decimal(14,2))
				ELSE 0 END AS RetencionSoles,
			CC.Numero,
			ENT.Nombre,
			e.Nombre NombreVendedor,
			COMP.IdVendedor,	
			CC.Fecha FechaEmision,
			CC.FechaVencimiento FechaVencimiento,
			MO.CodigoSunat,
			CC.Total,
			TC.Nombre TipoComprobante,
			CC.TipoCambio,
			T2.Abreviatura TipoDocumentoIdentidad,
			ETD.NumeroDocumento Ruc
	FROM ERP.CuentaCobrar CC
	LEFT JOIN ERP.FN_TotalPagosCuentaCobrar_Empresa(@IdEmpresa, @FechaDesde) TD
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
	INNER JOIN ERP.Comprobante COMP
		ON COMP.Documento = CC.Numero
	INNER JOIN ERP.Vendedor v
		ON v.ID = COMP.IdVendedor
	INNER JOIN ERP.Trabajador t
		ON t.ID = v.IdTrabajador
	INNER JOIN ERP.Entidad e
		ON e.ID = t.IdEntidad
	WHERE CC.Flag = 1 AND CC.IdEmpresa = @IdEmpresa
	AND CLI.ID IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaCliente,','))
	AND CC.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
	AND (
			(@TipoFecha = 1 AND CAST(CC.Fecha AS DATE) <= CAST(@FechaDesde AS DATE)) OR
			(@TipoFecha = 2 AND CAST(CC.FechaVencimiento AS DATE) between CAST(@FechaDesde AS DATE) AND CAST(@FechaHasta AS DATE))
		)
	AND CC.Total - ISNULL(TD.TotalPago, 0) > 0
END