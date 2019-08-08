CREATE PROC [ERP].[Usp_Sel_DocumentoCobrarDetalle_By_ClienteFechaEmision]
@IdCliente INT,
@IdEmpresa INT,
@ListaTipoComprobante VARCHAR(2500),
@Fecha DATETIME
AS
BEGIN
		SELECT CC.ID,
				CC.Serie,
				CC.Numero,
				ENT.Nombre,
				CC.Fecha,
				CC.FechaVencimiento,
				MO.CodigoSunat,
				CASE
					WHEN TC.CodigoSunat = '07' THEN CC.Total * -1
					ELSE CC.Total
				END Total,
				TC.Nombre TipoComprobante,
				CC.TipoCambio,			
				CASE
					 WHEN CC.IdMoneda = 1 THEN
						CASE
							WHEN TC.CodigoSunat = '07' THEN (SELECT(ERP.SaldoTotalCuentaCobrarDeSolesPorFecha(CC.ID, @Fecha))) * -1
							ELSE (SELECT(ERP.SaldoTotalCuentaCobrarDeSolesPorFecha(CC.ID, @Fecha))) END
					 ELSE NULL END SaldoSoles,
				CASE
					WHEN CC.IdMoneda = 2 THEN
						CASE
							WHEN TC.CodigoSunat = '07' THEN (SELECT(ERP.SaldoTotalCuentaCobrarDeDolaresPorFecha(CC.ID, @Fecha))) * -1
							ELSE (SELECT(ERP.SaldoTotalCuentaCobrarDeDolaresPorFecha(CC.ID, @Fecha))) END
					ELSE NULL END SaldoDolares
		FROM ERP.CuentaCobrar CC
		INNER JOIN Maestro.Moneda MO
		ON MO.ID = CC.IdMoneda
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CC.IdTipoComprobante
		INNER JOIN ERP.Entidad ENT
		ON ENT.ID = CC.IdEntidad
		INNER JOIN ERP.Cliente CLI
		ON CLI.IdEntidad = ENT.ID
		WHERE CC.Flag = 1 AND CLI.ID = @IdCliente AND CC.IdEmpresa = @IdEmpresa
		AND CC.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
		AND CAST(CC.Fecha AS DATE)<= CAST(@Fecha AS DATE)
		AND ISNULL(CASE 
					WHEN CC.IdMoneda = 1 THEN ISNULL((SELECT(ERP.SaldoTotalCuentaCobrarDeSolesPorFecha(CC.ID,@Fecha))), 0) 
					ELSE ISNULL((SELECT(ERP.SaldoTotalCuentaCobrarDeDolaresPorFecha(CC.ID,@Fecha))),0) END,0 ) <> 0 
END