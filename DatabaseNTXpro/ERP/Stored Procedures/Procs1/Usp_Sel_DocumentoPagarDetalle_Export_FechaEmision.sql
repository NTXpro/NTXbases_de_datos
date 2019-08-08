CREATE PROC [ERP].[Usp_Sel_DocumentoPagarDetalle_Export_FechaEmision]
@ListaProveedor VARCHAR(250),
@ListaTipoComprobante VARCHAR(250),
@FechaEmision DATETIME
AS
BEGIN
			SELECT CP.ID,
				   CP.Serie,
				   SUM(IIF(CP.IdMoneda = 1 ,CP.Total,'0.0000')*IIF(CP.IdTipoComprobante = 8,-1,1))		AS TotalSoles,
				   SUM(IIF(CP.IdMoneda = 2 ,CP.Total,'0.0000')*IIF(CP.IdTipoComprobante = 8,-1,1))		AS TotalDolares,
				   (SELECT ([ERP].[ObtenerTotalSaldoSolesByCuentaPagar](CP.ID))) AS SaldoSoles,
				   (SELECT ([ERP].[ObtenerTotalSaldoDolaresByCuentaPagar](CP.ID))) AS SaldoDolares,
				   CP.Numero,
				   ENT.Nombre,
				   CP.Fecha		FechaEmision,
				   CP.FechaVencimiento FechaVencimiento,
				   MO.CodigoSunat,
				   CP.Total,
				   TC.Nombre TipoComprobante,
				   CP.TipoCambio,
				   ETD.NumeroDocumento Ruc
			FROM ERP.CuentaPagar CP
			INNER JOIN Maestro.Moneda MO
			ON MO.ID = CP.IdMoneda
			INNER JOIN PLE.T10TipoComprobante TC
			ON TC.ID = CP.IdTipoComprobante
			INNER JOIN ERP.Entidad ENT
			ON ENT.ID = CP.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = ENT.ID
			INNER JOIN ERP.Proveedor PRO
			ON PRO.IdEntidad = ENT.ID
			WHERE CP.Flag = 1 AND PRO.ID IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaProveedor,','))
			AND CP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
			AND CP.Fecha <= @FechaEmision
			GROUP BY CP.ID,CP.Serie,CP.Numero,MO.CodigoSunat,CP.Total,TC.Nombre,CP.TipoCambio,ENT.Nombre,ETD.NumeroDocumento,CP.Fecha,CP.FechaVencimiento
END

