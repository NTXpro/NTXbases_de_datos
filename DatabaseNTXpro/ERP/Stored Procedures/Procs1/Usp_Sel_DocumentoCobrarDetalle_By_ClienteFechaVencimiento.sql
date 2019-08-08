CREATE PROC [ERP].[Usp_Sel_DocumentoCobrarDetalle_By_ClienteFechaVencimiento]
@IdCliente INT,
@IdEmpresa INT,
@ListaTipoComprobante VARCHAR(250),
@Fecha DATETIME,
@FechaHasta DATETIME 
AS
BEGIN
	SELECT CC.ID,
			CC.Serie,
			CC.Numero,
			ENT.Nombre,
			CC.Fecha,
			CC.FechaVencimiento,
			MO.CodigoSunat,
			CC.Total,
			TC.Nombre TipoComprobante,
			CC.TipoCambio,
			CASE
				WHEN CC.IdMoneda = 1 THEN (SELECT(ERP.SaldoTotalCuentaCobrarDeSolesPorFecha(CC.ID, CAST('9999-12-31 23:59:59.997' AS DateTime))))  
				ELSE NULL END SaldoSoles,
			CASE WHEN CC.IdMoneda = 2 THEN (SELECT(ERP.SaldoTotalCuentaCobrarDeDolaresPorFecha(CC.ID, CAST('9999-12-31 23:59:59.997' AS DateTime)))) 
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
	WHERE CC.Flag = 1 AND CLI.ID = @IdCliente 
	AND CC.IdEmpresa = @IdEmpresa
	AND CC.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
	AND CAST(CC.FechaVencimiento AS DATE) BETWEEN  CAST(@Fecha AS DATE) AND  CAST(@FechaHasta AS DATE)
	AND ISNULL(CASE WHEN CC.IdMoneda = 1 THEN ISNULL((SELECT(ERP.SaldoTotalCuentaCobrarDeSolesPorFecha(CC.ID,@Fecha))),0) ELSE ISNULL((SELECT(ERP.SaldoTotalCuentaCobrarDeDolaresPorFecha(CC.ID,@Fecha))),0) END,0 ) > 0 
END


--ALTER PROC [ERP].[Usp_Sel_DocumentoPagarDetalle_By_Proveedor]
--@IdProveedor INT,
--@IdEmpresa INT,
--@ListaTipoComprobante VARCHAR(MAX),
--@FechaVencimiento DATETIME
--AS
--BEGIN

--			DECLARE @Mes INT = (SELECT MONTH(@FechaVencimiento));

--			DECLARE @Anio INT = (SELECT YEAR(@FechaVencimiento));

			
--			DECLARE @IdPeriodo INT = (SELECT PE.ID
--										FROM ERP.Periodo PE 
--										INNER JOIN Maestro.Anio AN ON AN.ID = PE.IdAnio
--										INNER JOIN Maestro.Mes ME ON ME.ID = PE.IdMes
--										WHERE AN.Nombre = @Anio AND ME.Valor = @Mes)


--			SELECT CP.ID,
--				   CP.Serie,
--				   CP.Numero,
--				   ENT.Nombre,
--				   MO.CodigoSunat,
--				   CP.Total,
--				   TC.Nombre TipoComprobante,
--				   CP.TipoCambio,
--				   CP.Fecha FechaEmision,
--				   CP.FechaVencimiento FechaVencimiento,
--				   ISNULL(CASE WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 1 THEN
--						(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID, CAST('9999-12-31 23:59:59.997' AS DateTime))))*(-1)
--					WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 2 THEN
--						(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID, CAST('9999-12-31 23:59:59.997' AS DateTime))))
--					END,0)										SaldoSoles,

--					ISNULL(CASE WHEN CP.IdMoneda = 2 AND CP.IdDebeHaber = 1 THEN
--						(SELECT(ERP.SaldoTotalCuentaPagarDeDolaresPorFecha(CP.ID, CAST('9999-12-31 23:59:59.997' AS DateTime))))*(-1)
--					WHEN CP.IdMoneda = 2 AND CP.IdDebeHaber = 2 THEN
--						(SELECT(ERP.SaldoTotalCuentaPagarDeDolaresPorFecha(CP.ID, CAST('9999-12-31 23:59:59.997' AS DateTime))))
--					END,0)										SaldoDolares
						
--				   --(SELECT [ERP].[ObtenerTotalSaldoSolesByCuentaPagar](CP.ID,@FechaVencimiento))		SaldoSoles,
--				   --(SELECT [ERP].[ObtenerTotalSaldoDolaresByCuentaPagar](CP.ID,@FechaVencimiento))	SaldoDolares
--			FROM ERP.CuentaPagar CP
--			INNER JOIN Maestro.Moneda MO
--			ON MO.ID = CP.IdMoneda
--			INNER JOIN PLE.T10TipoComprobante TC
--			ON TC.ID = CP.IdTipoComprobante
--			INNER JOIN ERP.Entidad ENT
--			ON ENT.ID = CP.IdEntidad
--			INNER JOIN ERP.Proveedor PRO
--			ON PRO.IdEntidad = ENT.ID
--			WHERE CP.Flag = 1 AND PRO.ID = @IdProveedor AND CP.IdEmpresa = @IdEmpresa
--			AND CP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
--			AND CAST(CP.FechaVencimiento AS DATE) <= CAST(@FechaVencimiento AS DATE)
--			AND CP.IdPeriodo <= @IdPeriodo
--			AND ISNULL(CAST(CASE WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 1 THEN
--						(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID,@FechaVencimiento)))*(-1)
--					WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 2 THEN
--						(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID,@FechaVencimiento)))
--					END AS DECIMAL(14,2)),0) > 0 
--END