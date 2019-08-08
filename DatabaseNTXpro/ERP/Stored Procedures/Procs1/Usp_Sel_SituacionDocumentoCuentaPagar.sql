CREATE PROCEDURE [ERP].[Usp_Sel_SituacionDocumentoCuentaPagar]
@TipoFecha INT,
@EstadoDocumento INT,
@Fecha DATETIME,
@FechaHasta DATETIME,
@IdProveedor INT,
@IdEmpresa INT
AS
BEGIN
		DECLARE @Mes INT = (SELECT MONTH(@Fecha));

		DECLARE @Anio INT = (SELECT YEAR(@Fecha));
			
		DECLARE @IdPeriodo INT = (SELECT PE.ID
									FROM ERP.Periodo PE 
									INNER JOIN Maestro.Anio AN ON AN.ID = PE.IdAnio
									INNER JOIN Maestro.Mes ME ON ME.ID = PE.IdMes
									WHERE AN.Nombre = @Anio AND ME.Valor = @Mes)

		DECLARE @IdEntidad INT = (SELECT IdEntidad FROM ERP.Proveedor WHERE ID = @IdProveedor)

		DECLARE @Fecha2 DATETIME = (SELECT
										CASE
											WHEN @TipoFecha = 1 THEN @Fecha
											WHEN @TipoFecha = 2 THEN @FechaHasta
										END)

		SELECT	ST.Proveedor,
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
				ST.FechaRecepcion,
				ST.IdPeriodo,
				ST.IdEmpresa,
				ST.Saldo,
				ST.Debe,
				ST.Haber

		FROM 												
		(SELECT		ENT.Nombre											Proveedor,
					CP.ID												ID,
					CP.Fecha											FechaEmision,
					CP.IdMoneda											IdMoneda,
					CP.FechaVencimiento									FechaVencimiento,
					TC.Nombre											TipoComprobante,
					CP.Serie											Serie,
					CP.Numero											Documento,
					CP.Total											Total,
					CP.TipoCambio										TipoCambio,
					MO.CodigoSunat										Moneda,
					CCO.Nombre											Origen,
					CP.IdEntidad										IdEntidad,
					CP.Flag												Flag,
					CP.FlagCancelo										FlagCancelo,	
					CP.IdTipoComprobante								IdTipoComprobante,
					CP.FechaRecepcion									FechaRecepcion,
					CP.IdPeriodo										IdPeriodo,
					CP.IdEmpresa										IdEmpresa,
					(CASE WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 1 THEN
								(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID,@Fecha2)))*(-1)
							WHEN CP.IdMoneda = 1 AND CP.IdDebeHaber = 2 THEN
								(SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID,@Fecha2)))
							WHEN CP.IdMoneda = 2 AND CP.IdDebeHaber = 1 THEN
								(SELECT(ERP.SaldoTotalCuentaPagarDeDolaresPorFecha(CP.ID,@Fecha2)))*(-1)
							WHEN CP.IdMoneda = 2 AND CP.IdDebeHaber = 2 THEN
								(SELECT(ERP.SaldoTotalCuentaPagarDeDolaresPorFecha(CP.ID,@Fecha2)))
							END) AS Saldo,
					(CASE WHEN CP.IdDebeHaber = 1 AND CP.IdMoneda = 1 THEN CP.Total
							WHEN CP.IdDebeHaber = 1 AND CP.IdMoneda = 2 THEN CP.Total
							END) AS Debe,
					(CASE WHEN CP.IdDebeHaber = 2 AND CP.IdMoneda = 1 THEN CP.Total
							WHEN CP.IdDebeHaber = 2 AND CP.IdMoneda = 2 THEN CP.Total
							END) AS Haber
			FROM ERP.CuentaPagar CP
			INNER JOIN ERP.Entidad ENT ON ENT.ID = CP.IdEntidad
			INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CP.IdTipoComprobante
			INNER JOIN Maestro.Moneda MO ON MO.ID = CP.IdMoneda
			INNER JOIN Maestro.CuentaPagarOrigen CCO ON CCO.ID = CP.IdCuentaPagarOrigen
			INNER JOIN Maestro.DebeHaber DH ON DH.ID = CP.IdDebeHaber) AS ST 
			WHERE (
				(@TipoFecha = 1 AND CAST(ST.FechaEmision AS DATE) <= CAST(@Fecha2 AS DATE)) OR
				(@TipoFecha = 2 AND CAST(ST.FechaVencimiento AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@Fecha2 AS DATE))
			   )
			AND ST.IdEntidad = @IdEntidad 
			AND ST.Flag = 1  AND ST.IdEmpresa = @IdEmpresa
			--AND ST.IdPeriodo <= @IdPeriodo
			AND ((@EstadoDocumento = -1) OR (@EstadoDocumento = 0 AND ST.Saldo != 0) OR (@EstadoDocumento = 1 AND ST.Saldo = 0))
			ORDER BY ST.IdTipoComprobante DESC
				
END