﻿CREATE  FUNCTION [ERP].[ObtenerTotalMovimientoCuentaPagarDolaresByProveedorFechaEmision](
		@IdProveedor INT,
		@ListaTipoComprobante VARCHAR(250),
		@FechaVencimiento DATETIME
		)
		RETURNS DECIMAL (15,5)
		AS
		BEGIN

			DECLARE @Total DECIMAL(14,5);
			DECLARE @TotalMovimientoCuentaPagarDolares DECIMAL (14,2);
			DECLARE @TotalCuentaPagarDolares DECIMAL(14,5);
			DECLARE @TotalAplicacionAnticipo DECIMAL(14,5);

			/*ID CUENTA PAGAR QUE VIENE DE UN ANTICIPO O DE UNA NOTA DE CRÉDITO*/

			DECLARE @IdTipoComprobante TABLE (ID INT)

			INSERT INTO @IdTipoComprobante SELECT ID FROM PLE.T10TipoComprobante WHERE ID IN (8,55,60,183)

			DECLARE @IdTipoComprobanteCuentaPagar TABLE (ID INT)

			INSERT INTO @IdTipoComprobanteCuentaPagar SELECT CP.IdTipoComprobante
																FROM ERP.CuentaPagar CP
																INNER JOIN ERP.Entidad ENT ON ENT.ID = CP.IdEntidad
																INNER JOIN ERP.Proveedor PRO ON PRO.IdEntidad = ENT.ID
																WHERE PRO.ID = @IdProveedor 
																AND CP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
																AND CAST(CP.Fecha AS DATE )<= CAST(@FechaVencimiento AS DATE)

			/******************************************/


			SET  @TotalCuentaPagarDolares = (SELECT 
											SUM(IIF(CP.IdMoneda = 2 ,CP.Total,'0.0000')*IIF(CP.IdTipoComprobante = 8,-1,1)) --COMMEND MAIKITO
											--SUM(IIF(CP.IdMoneda = 2 ,CP.Total,IIF(CP.IdMoneda = 1 ,CP.Total / CP.TipoCambio,'0.0000'))*IIF(CP.IdTipoComprobante = 8,-1,1))
											FROM ERP.CuentaPagar CP
											INNER JOIN ERP.Entidad ENT ON ENT.ID = CP.IdEntidad
											INNER JOIN ERP.Proveedor PRO ON PRO.IdEntidad = ENT.ID
											WHERE PRO.ID = @IdProveedor AND CP.Flag = 1  
											AND CP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
											AND CAST(CP.Fecha AS DATE)<= CAST(@FechaVencimiento AS DATE  ))
			
			SET  @TotalMovimientoCuentaPagarDolares = (SELECT 
													-- SUM(IIF(CP.IdMoneda = 2 ,MTD.Total,'0.0000')*IIF(CP.IdTipoComprobante = 8,-1,1)) --COMMEND MAIKITO
														SUM(IIF(CP.IdMoneda = 2 AND MT.ID = 2,MTD.Total,IIF(CP.IdMoneda = 2 AND MT.IdMoneda = 1,MTD.Total / MT.TipoCambio,'0.0000'))*IIF(CP.IdTipoComprobante = 8,-1,1))
													 FROM ERP.MovimientoTesoreriaDetalleCuentaPagar MDCP
													 INNER JOIN ERP.CuentaPagar CP ON CP.ID = MDCP. IdCuentaPagar
													 INNER JOIN ERP.Entidad ENT ON ENT.ID = CP.IdEntidad
													 INNER JOIN ERP.Proveedor PRO ON PRO.IdEntidad = ENT.ID
									 			     INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCP.IdMovimientoTesoreriaDetalle
									 			     INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
												     INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
												     WHERE PRO.ID = @IdProveedor AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MTD.IdDebeHaber = 1 
													 AND CP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
													 AND CAST(MT.Fecha AS DATE)<= CAST(@FechaVencimiento AS DATE))	

			SET @TotalAplicacionAnticipo = (SELECT SUM (CASE WHEN AAP.IdMoneda = 2 AND CP.IdMoneda = 2 THEN
																				AAPD.TotalAplicado
																			WHEN AAP.IdMoneda = 1 AND CP.IdMoneda = 2 THEN
																				ROUND((AAPD.TotalAplicado / AAP.TipoCambio),2)
																			ELSE
																				'0.0000'	
																			END
																				)
																		FROM ERP.AplicacionAnticipoPagar AAP
																		INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
																		INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAPD.IdCuentaPagar
																		INNER JOIN ERP.Entidad ENT ON ENT.ID = CP.IdEntidad
																		INNER JOIN ERP.Proveedor PRO ON PRO.IdEntidad = ENT.ID
																		WHERE PRO.ID = @IdProveedor
																		AND CP.IdTipoComprobante IN (SELECT DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
																		AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@FechaVencimiento AS DATE))

			SET @Total = ISNULL(@TotalCuentaPagarDolares,0) - ISNULL(@TotalMovimientoCuentaPagarDolares,0) - ISNULL(@TotalAplicacionAnticipo,0)
									 
			RETURN @Total

		END
