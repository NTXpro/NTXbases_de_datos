CREATE PROC [ERP].[Usp_Obtener_Totales] @IdEmpresa            INT, 
                                       @ListaTipoComprobante VARCHAR(MAX), 
                                       @FechaDesde               DATETIME,
									   @ListaCliente VARCHAR(MAX),
									   @TipoFecha int,
									   @FechaHasta DATETIME
AS
     BEGIN
        SELECT ENT.Nombre  NombreCliente,
		                            TotalSoles,
		                            TotalDolares,
		                            SaldoSoles,
		                            SaldoDolares,
		                            CLI.ID,
		                            ETD.NumeroDocumento  Ruc,
		                            MostrarItem
                            FROM (
		                          SELECT SUM(CASE
						                            WHEN CC.IdMoneda = 1 THEN CC.Total * IIF(CC.IdDebeHaber = 2, -1, 1)
						                            ELSE 0 END) TotalSoles,
				                            SUM(CASE
						                            WHEN CC.IdMoneda = 2 THEN CC.Total * IIF(CC.IdDebeHaber = 2, -1, 1)
						                            ELSE 0 END) TotalDolares,
											SUM(CASE
						                            WHEN CC.IdMoneda = 1 THEN (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
						                            ELSE 0 END) SaldoSoles,
				                            SUM(CASE
						                            WHEN CC.IdMoneda = 2 THEN (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
						                            ELSE 0 END) SaldoDolares,
				                            --SUM(CASE
						                          --  WHEN CC.IdMoneda = 1 THEN (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
						                          --  ELSE ((CC.Total - ISNULL(TD.TotalPago, 0)) * CC.TipoCambio) * IIF(CC.IdDebeHaber = 2, -1, 1) END) SaldoConvSoles,
				                            --SUM(CASE
						                          --  WHEN CC.IdMoneda = 2 THEN (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1)
						                          --  ELSE ((CC.Total - ISNULL(TD.TotalPago, 0)) / CC.TipoCambio) * IIF(CC.IdDebeHaber = 2, -1, 1) END) SaldoConvDolares,
				                            SUM(CASE 
					                            WHEN CC.Total - ISNULL(TD.TotalPago, 0) = 0 
						                            THEN 0 
						                            ELSE 1
				                            END) MostrarItem,
				                            CC.IdEntidad
		                            FROM ERP.CuentaCobrar CC
		                            LEFT JOIN ERP.FN_TotalPagosCuentaCobrar_Empresa(@IdEmpresa, @FechaDesde) TD ON CC.ID = TD.IdCuentaCobrar
		                            WHERE CC.Flag = 1
		                            AND CC.IdEmpresa = @IdEmpresa
		                            AND CC.IdTipoComprobante IN (SELECT DATA
										                            FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
		                            AND (
				                            (@TipoFecha = 1 AND CAST(CC.Fecha AS DATE) <= CAST(@FechaDesde AS datetime) ) OR
				                            (@TipoFecha = 2 AND  CAST(CC.Fecha AS DATE) between CAST(@FechaDesde AS DATE) and CAST(@FechaHasta as date))
			                            )
									AND (
											IIF(CC.IdMoneda = 1, (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1), 0) > 0 OR 
											IIF(CC.IdMoneda = 2, (CC.Total - ISNULL(TD.TotalPago, 0)) * IIF(CC.IdDebeHaber = 2, -1, 1), 0) > 0
										)	 		
		                            GROUP BY CC.IdEntidad
	                            ) TOTAL_DEUDA_CC
                            INNER JOIN ERP.Entidad ENT
                            ON ENT.ID = TOTAL_DEUDA_CC.IdEntidad
                            INNER JOIN ERP.EntidadTipoDocumento ETD
                            ON ETD.IdEntidad = ENT.ID
                            INNER JOIN ERP.Cliente CLI
                           ON CLI.IdEntidad = ENT.ID
                            WHERE CLI.ID IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaCliente,','))
                           
						END