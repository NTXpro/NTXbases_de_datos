


CREATE PROC [ERP].[Usp_Sel_DocumentoPagarDetalle_By_Proveedor]
@IdProveedor INT,
@IdEmpresa INT,
@ListaTipoComprobante VARCHAR(MAX),
@FechaVencimiento DATETIME,
@FechaHasta DATETIME 

AS
BEGIN

			DECLARE @Mes INT = (SELECT MONTH(@FechaVencimiento));

			DECLARE @Anio INT = (SELECT YEAR(@FechaVencimiento));

			
			DECLARE @IdPeriodo INT = (SELECT PE.ID
										FROM ERP.Periodo PE 
										INNER JOIN Maestro.Anio AN ON AN.ID = PE.IdAnio
										INNER JOIN Maestro.Mes ME ON ME.ID = PE.IdMes
										WHERE AN.Nombre = @Anio AND ME.Valor = @Mes)


			SELECT CP.ID,
				   CP.Serie,
				   CP.Numero,
				   ENT.Nombre,
				   MO.CodigoSunat,
				   CP.Total,
				   TC.Nombre TipoComprobante,
				   CP.TipoCambio,
				   CP.Fecha FechaEmision,
				   CP.FechaVencimiento FechaVencimiento,
				   ISNULL(CASE WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 1 THEN
						(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID, CAST('9999-12-31 23:59:59.997' AS DateTime))))*(-1)
					WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 2 THEN
						(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID, CAST('9999-12-31 23:59:59.997' AS DateTime))))
					END,0)										SaldoSoles,

					ISNULL(CASE WHEN CP.IdMoneda = 2 AND CP.IdDebeHaber = 1 THEN
						(SELECT(ERP.SaldoTotalCuentaPagarDeDolaresPorFecha(CP.ID, CAST('9999-12-31 23:59:59.997' AS DateTime))))*(-1)
					WHEN CP.IdMoneda = 2 AND CP.IdDebeHaber = 2 THEN
						(SELECT(ERP.SaldoTotalCuentaPagarDeDolaresPorFecha(CP.ID, CAST('9999-12-31 23:59:59.997' AS DateTime))))
					END,0)										SaldoDolares
						
				   --(SELECT [ERP].[ObtenerTotalSaldoSolesByCuentaPagar](CP.ID,@FechaVencimiento))		SaldoSoles,
				   --(SELECT [ERP].[ObtenerTotalSaldoDolaresByCuentaPagar](CP.ID,@FechaVencimiento))	SaldoDolares
			FROM ERP.CuentaPagar CP
			INNER JOIN Maestro.Moneda MO
			ON MO.ID = CP.IdMoneda
			INNER JOIN PLE.T10TipoComprobante TC
			ON TC.ID = CP.IdTipoComprobante
			INNER JOIN ERP.Entidad ENT
			ON ENT.ID = CP.IdEntidad
			INNER JOIN ERP.Proveedor PRO
			ON PRO.IdEntidad = ENT.ID
			WHERE CP.Flag = 1 AND PRO.ID = @IdProveedor AND CP.IdEmpresa = @IdEmpresa
			AND CP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
			AND CAST(CP.FechaVencimiento AS DATE) BETWEEN  CAST(@FechaVencimiento AS DATE) AND  CAST(@FechaHasta AS DATE)
			AND CP.IdPeriodo <= @IdPeriodo
			AND ISNULL(CAST(CASE WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 1 THEN
						(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID,@FechaVencimiento)))*(-1)
					WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 2 THEN
						(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID,@FechaVencimiento)))
					END AS DECIMAL(14,2)),0) > 0 
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