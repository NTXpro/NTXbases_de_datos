CREATE PROC [ERP].[Usp_Sel_DocumentoCobrarDetalleFechaEmision_Export]
@ListaCliente VARCHAR(250),
@ListaTipoComprobante VARCHAR(250),
@Fecha DATETIME
AS
BEGIN
			SELECT CC.ID,
				   CC.Serie,
				   SUM(IIF(CC.IdMoneda = 1 ,CC.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))		AS TotalSoles,
				   SUM(IIF(CC.IdMoneda = 2 ,CC.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))		AS TotalDolares,
				    (SELECT (ERP.ObtenerTotalSaldoSolesByCuentaCobrar(CC.ID))) AS SaldoSoles,
				   (SELECT (ERP.ObtenerTotalSaldoDolaresByCuentaCobrar(CC.ID))) AS SaldoDolares,
				   CC.Numero,
				   ENT.Nombre,
				   CC.Fecha		FechaEmision,
				   CC.FechaVencimiento FechaVencimiento,
				   MO.CodigoSunat,
				   CC.Total,
				   TC.Nombre TipoComprobante,
				   CC.TipoCambio,
				   ETD.NumeroDocumento Ruc
			FROM ERP.CuentaCobrar CC
			INNER JOIN Maestro.Moneda MO
			ON MO.ID = CC.IdMoneda
			INNER JOIN PLE.T10TipoComprobante TC
			ON TC.ID = CC.IdTipoComprobante
			INNER JOIN ERP.Entidad ENT
			ON ENT.ID = CC.IdEntidad
			INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = ENT.ID
			INNER JOIN ERP.Cliente CLI
			ON CLI.IdEntidad = ENT.ID
			WHERE CC.Flag = 1 
			AND CLI.ID IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaCliente,','))
			AND CC.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
			AND CAST(CC.Fecha AS DATE)<= CAST(@Fecha AS DATE)
			GROUP BY CC.ID,CC.Serie,CC.Numero,MO.CodigoSunat,CC.Total,TC.Nombre,CC.TipoCambio,ENT.Nombre,ETD.NumeroDocumento,CC.Fecha,CC.FechaVencimiento
END
