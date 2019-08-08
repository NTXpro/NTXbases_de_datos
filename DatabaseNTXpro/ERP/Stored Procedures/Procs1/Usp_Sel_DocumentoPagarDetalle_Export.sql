CREATE PROC [ERP].[Usp_Sel_DocumentoPagarDetalle_Export]
@ListaProveedor VARCHAR(MAX),
@ListaTipoComprobante VARCHAR(MAX),
@Fecha DATETIME,
@IdEmpresa INT,
@TipoFecha INT
AS
BEGIN
	SELECT CP.ID,
			CP.Serie,
			CASE
				WHEN CP.IdMoneda = 1 THEN CP.Total * IIF(CP.IdDebeHaber = 1, -1, 1)
				ELSE 0 END TotalSoles,
			CASE
				WHEN CP.IdMoneda = 2 THEN CP.Total * IIF(CP.IdDebeHaber = 1, -1, 1)
				ELSE 0 END TotalDolares,
			CASE
				WHEN CP.IdMoneda = 1 THEN (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 1, -1, 1)
				ELSE 0 END SaldoSoles,
			CASE
				WHEN CP.IdMoneda = 2 THEN (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 1, -1, 1)
				ELSE 0 END SaldoDolares,
			--CASE
			--	WHEN CP.IdMoneda = 1 THEN (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 1, -1, 1)
			--	ELSE ((CP.Total - ISNULL(TD.TotalPago, 0)) * CP.TipoCambio) * IIF(CP.IdDebeHaber = 1, -1, 1) END SaldoSoles,
			--CASE
			--	WHEN CP.IdMoneda = 2 THEN (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 1, -1, 1)
			--	ELSE ((CP.Total - ISNULL(TD.TotalPago, 0)) / CP.TipoCambio) * IIF(CP.IdDebeHaber = 1, -1, 1) END SaldoDolares,
			CP.Numero,
			ENT.Nombre,
			CP.Fecha		FechaEmision,
			CP.FechaVencimiento FechaVencimiento,
			MO.CodigoSunat,
			CP.Total,
			TC.Nombre TipoComprobante,
			CP.TipoCambio,
			T2.Abreviatura TipoDocumentoIdentidad,
			ETD.NumeroDocumento Ruc
	FROM ERP.CuentaPagar CP
	LEFT JOIN ERP.FN_TotalPagosCuentaPagar_Empresa(@IdEmpresa, @Fecha) TD ON CP.ID = TD.IdCuentaPagar
	INNER JOIN Maestro.Moneda MO
		ON MO.ID = CP.IdMoneda
	INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CP.IdTipoComprobante
	INNER JOIN ERP.Entidad ENT
		ON ENT.ID = CP.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = ENT.ID
	INNER JOIN PLE.T2TipoDocumento T2 
		ON T2.ID = ETD.IdTipoDocumento
	INNER JOIN ERP.Proveedor PRO
		ON PRO.IdEntidad = ENT.ID
	WHERE CP.Flag = 1 AND CP.IdEmpresa = @IdEmpresa
	AND PRO.ID IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaProveedor,','))
	AND CP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
	AND (
			(@TipoFecha = 1 AND CAST(CP.Fecha AS DATE) <= CAST(@Fecha AS DATE)) OR
			(@TipoFecha = 2 AND CAST(CP.FechaVencimiento AS DATE) <= CAST(@Fecha AS DATE))
		)
	AND CP.Total - ISNULL(TD.TotalPago, 0) <> 0
END