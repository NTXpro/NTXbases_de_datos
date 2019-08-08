CREATE PROC [ERP].[Usp_Sel_SituacionDocumentoDetalleCuentaCobrarConsolidado]
	@Fecha DATETIME
	AS
	BEGIN
	SELECT CC.ID					IdCuentaCabecera,
		   ENTB.Nombre				Serie,
		   MT.Orden				Movimiento,
		   C.Nombre					Documento,
		   MT.Fecha,
		   MT.TipoCambio,
		   TC.Nombre				TipoComprobante,
		   MO.CodigoSunat			Moneda,
		   CASE WHEN MTD.IdDebeHaber = 1 THEN
			   CASE WHEN CC.IdMoneda = 1 AND MT.IdMoneda = 1 THEN
						MTD.Total
			   WHEN CC.IdMoneda = 2 AND MT.IdMoneda = 1 THEN
						ROUND((MTD.Total/MT.TipoCambio),2)
			   WHEN CC.IdMoneda = 2 AND MT.IdMoneda = 2 THEN
						MTD.Total
			   WHEN CC.IdMoneda = 1 AND MT.IdMoneda = 2 THEN
						ROUND((MTD.Total*MT.TipoCambio),2)
				END											
			END										Debe,
			
			CASE WHEN MTD.IdDebeHaber = 2 THEN
			   CASE WHEN CC.IdMoneda = 1 AND MT.IdMoneda = 1 THEN
						MTD.Total
			   WHEN CC.IdMoneda = 2 AND MT.IdMoneda = 1 THEN
						ROUND((MTD.Total/MT.TipoCambio),2)
			   WHEN CC.IdMoneda = 2 AND MT.IdMoneda = 2 THEN
						MTD.Total
			   WHEN CC.IdMoneda = 1 AND MT.IdMoneda = 2 THEN
						ROUND((MTD.Total*MT.TipoCambio),2)
				END											
			END										Haber															
	FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MTDCC
	INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTDCC.IdMovimientoTesoreriaDetalle = MTD.ID
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
	INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
	--INNER JOIN PLE.T3Banco BA ON BA.ID = C.IdBanco
	INNER JOIN ERP.Entidad ENTB ON ENTB.ID = C.IdEntidad
	INNER JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
	INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MTDCC.IdCuentaCobrar
	INNER JOIN ERP.Entidad ENT ON ENT.ID = CC.IdEntidad
    INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CC.IdTipoComprobante
    INNER JOIN Maestro.Moneda MO ON MO.ID = CC.IdMoneda
	WHERE  MT.Flag = 1 AND MT.FlagBorrador = 0 AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE)

	UNION ALL 
	/*********************** APLICACION ANTICIPO / CUENTAS POR COBRAR QUE SE REALIZAN EN EL DETALLE *********************/

	SELECT CC.ID					IdCuentaCabecera,
		   'APLICACIÓN ANTICIPO'		Serie,
		   ''							Movimiento,
		   AAP.Documento					Documento,
		   AAP.FechaAplicacion			Fecha,
		   AAP.TipoCambio,
		   TC.Nombre					TipoComprobante,
		   MO.CodigoSunat				Moneda,
		   CASE WHEN AAPD.IdDebeHaber = 1 THEN
			   CASE WHEN CC.IdMoneda = 1 AND AAP.IdMoneda = 1 THEN	
						AAPD.TotalAplicado
			   WHEN CC.IdMoneda = 2 AND AAP.IdMoneda = 1 THEN
						ROUND((AAPD.TotalAplicado/AAP.TipoCambio),2)
			   WHEN CC.IdMoneda = 2 AND AAP.IdMoneda = 2 THEN
						AAPD.TotalAplicado
			   WHEN CC.IdMoneda = 1 AND AAP.IdMoneda = 2 THEN
						ROUND((AAPD.TotalAplicado*AAP.TipoCambio),2)
			   END	
			END											Haber,

			CASE WHEN AAPD.IdDebeHaber = 2 THEN
			   CASE WHEN CC.IdMoneda = 1 AND AAP.IdMoneda = 1 THEN	
						AAPD.TotalAplicado
			   WHEN CC.IdMoneda = 2 AND AAP.IdMoneda = 1 THEN
						ROUND((AAPD.TotalAplicado/AAP.TipoCambio),2)
			   WHEN CC.IdMoneda = 2 AND AAP.IdMoneda = 2 THEN
						AAPD.TotalAplicado
			   WHEN CC.IdMoneda = 1 AND AAP.IdMoneda = 2 THEN
						ROUND((AAPD.TotalAplicado*AAP.TipoCambio),2)
			   END	
			END											Debe
			 	 
	FROM ERP.AplicacionAnticipoCobrar AAP
	INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipoCobrar
	INNER JOIN ERP.CuentaCobrar CC ON CC.ID = AAPD.IdCuentaCobrar
	INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CC.IdTipoComprobante
	INNER JOIN Maestro.Moneda MO ON MO.ID = CC.IdMoneda
	WHERE CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE)

	UNION ALL 

	/*********************** APLICACION ANTICIPO / CUENTAS POR COBRAR QUE SE REALIZAN EN LA CABECERA (ANTICIPO Y NOTA DE CRÉDITO) *********************/
	SELECT CC.ID					IdCuentaCabecera,
		   TC.Nombre				Serie,
		   ''						Movimiento,
		   AAPD.Documento			Documento,
		   AAPD.Fecha				Fecha,
		   AAP.TipoCambio,
		   TC.Nombre			TipoComprobante,
		   MO.CodigoSunat			Moneda,
		   CASE WHEN AAPD.IdDebeHaber = 2 THEN
					AAPD.TotalAplicado    
		   END							Haber,

		   CASE WHEN AAPD.IdDebeHaber = 1 THEN
					AAPD.TotalAplicado    
			END							Debe

	FROM ERP.AplicacionAnticipoCobrar AAP
	INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipoCobrar
	INNER JOIN ERP.CuentaCobrar CC ON CC.ID = AAP.IdCuentaCobrar
	INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = AAPD.IdTipoComprobante
	INNER JOIN Maestro.Moneda MO ON MO.ID = CC.IdMoneda
	WHERE CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE)
	END
