CREATE PROC [ERP].[Usp_Obtener_TotalesPagar]
			@IdEmpresa				INT,
			@ListaTipoComprobante	VARCHAR(MAX),
			@FechaDesde				DATETIME,
			@ListaProveedor			VARCHAR(MAX),
			@TipoFecha				INT,
			@FechaHasta				DATETIME
AS
     BEGIN
        SELECT PROV.ID,
	                                    ENT.Nombre				NombreProveedor,
	                                    ETD.NumeroDocumento		Ruc,
	                                    TotalSoles,
	                                    TotalDolares,
	                                    SaldoSoles,
	                                    SaldoDolares
                                FROM (
		                                SELECT  SUM(CASE
						                                WHEN CP.IdMoneda = 1 THEN CP.Total * IIF(CP.IdDebeHaber = 1, -1, 1)
						                                ELSE 0 END) TotalSoles,
				                                SUM(CASE
						                                WHEN CP.IdMoneda = 2 THEN CP.Total * IIF(CP.IdDebeHaber = 1, -1, 1)
						                                ELSE 0 END) TotalDolares,
												SUM(CASE
						                                WHEN CP.IdMoneda = 1 THEN (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 1, -1, 1)
						                                ELSE 0 END) SaldoSoles,
				                                SUM(CASE
						                                WHEN CP.IdMoneda = 2 THEN (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 1, -1, 1)
						                                ELSE 0 END) SaldoDolares,
				                                --SUM(CASE
						                              --  WHEN CP.IdMoneda = 1 THEN (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 1, -1, 1)
						                              --  ELSE ((CP.Total - ISNULL(TD.TotalPago, 0)) * CP.TipoCambio) * IIF(CP.IdDebeHaber = 1, -1, 1) END) SaldoConvSoles,
				                                --SUM(CASE
						                              --  WHEN CP.IdMoneda = 2 THEN (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 1, -1, 1)
						                              --  ELSE ((CP.Total - ISNULL(TD.TotalPago, 0)) / CP.TipoCambio) * IIF(CP.IdDebeHaber = 1, -1, 1) END) SaldoConvDolares,
				                                SUM(CASE 
														WHEN CP.Total - ISNULL(TD.TotalPago, 0) = 0 
						                                THEN 0 
					                                ELSE 1
				                                END) MostrarItem,
				                                CP.IdEntidad
		                                FROM ERP.CuentaPagar CP
		                                LEFT JOIN ERP.FN_TotalPagosCuentaPagar_Empresa(@IdEmpresa, @FechaDesde) TD ON CP.ID = TD.IdCuentaPagar
		                                WHERE CP.Flag = 1
		                                AND CP.IdEmpresa = @IdEmpresa
		                                AND CP.IdTipoComprobante IN (SELECT DATA
										                                FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
		                                AND (
												(@TipoFecha = 1 AND CAST(CP.Fecha AS DATE) <= CAST(@FechaDesde AS datetime) ) OR
												(@TipoFecha = 2 AND  CAST(CP.Fecha AS DATE) between CAST(@FechaDesde AS DATE) and CAST(@FechaHasta as date))
											)
										AND (
												IIF(CP.IdMoneda = 1, (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 2, -1, 1), 0) <> 0 OR 
												IIF(CP.IdMoneda = 2, (CP.Total - ISNULL(TD.TotalPago, 0)) * IIF(CP.IdDebeHaber = 2, -1, 1), 0) <> 0
											)
		                                GROUP BY CP.IdEntidad
	                                ) TOTAL_DEUDA_CP
                                INNER JOIN ERP.Entidad ENT
									ON ENT.ID = TOTAL_DEUDA_CP.IdEntidad
                                INNER JOIN ERP.EntidadTipoDocumento ETD
									ON ETD.IdEntidad = ENT.ID
                                INNER JOIN ERP.Proveedor PROV
									ON PROV.IdEntidad = ENT.ID
                                WHERE PROV.ID IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaProveedor,','))
                                AND ((SaldoSoles <> 0 OR SaldoDolares <> 0))
END