CREATE PROC [ERP].[Usp_Sel_SituacionDocumentoDetalleCuentaCobrar]  
	@IdCuentaCobrar INT,
	@Fecha datetime,
	@FechaHasta datetime,
	@TipoFecha int 
	AS
	BEGIN
	SELECT ENTB.Nombre				Serie,
		   MT.Orden					Movimiento,
		   C.Nombre					Documento,
		   MT.Fecha					Fecha,
		   MT.TipoCambio			TipoCambio,
		   TC.Nombre				TipoComprobante,
		   MO.CodigoSunat			Moneda,
		   CASE
				WHEN MTD.IdDebeHaber = 2
					THEN
						CASE
							WHEN CC.IdMoneda = 1 AND MT.IdMoneda = 1 THEN MTD.Total
							WHEN CC.IdMoneda = 2 AND MT.IdMoneda = 1 THEN ROUND((MTD.Total/MT.TipoCambio),2)
							WHEN CC.IdMoneda = 2 AND MT.IdMoneda = 2 THEN MTD.Total
							WHEN CC.IdMoneda = 1 AND MT.IdMoneda = 2 THEN ROUND((MTD.Total*MT.TipoCambio),2)
						END											
			END						Haber,
			CASE
				WHEN MTD.IdDebeHaber = 1
					THEN
						CASE
							WHEN CC.IdMoneda = 1 AND MT.IdMoneda = 1 THEN MTD.Total
							WHEN CC.IdMoneda = 2 AND MT.IdMoneda = 1 THEN ROUND((MTD.Total/MT.TipoCambio),2)
							WHEN CC.IdMoneda = 2 AND MT.IdMoneda = 2 THEN MTD.Total
							WHEN CC.IdMoneda = 1 AND MT.IdMoneda = 2 THEN ROUND((MTD.Total*MT.TipoCambio),2)
						END											
			END						Debe															
	FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MTDCC
	INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTDCC.IdMovimientoTesoreriaDetalle = MTD.ID
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
	INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
	INNER JOIN ERP.Entidad ENTB ON ENTB.ID = C.IdEntidad
	INNER JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
	INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MTDCC.IdCuentaCobrar
	INNER JOIN ERP.Entidad ENT ON ENT.ID = CC.IdEntidad
    INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CC.IdTipoComprobante
    INNER JOIN Maestro.Moneda MO ON MO.ID = CC.IdMoneda
	WHERE CC.ID = @IdCuentaCobrar AND MT.Flag = 1 AND MT.FlagBorrador = 0
	AND (
			(@TipoFecha = 1 AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE)) OR
			(@TipoFecha = 2 AND CAST(MT.Fecha AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@FechaHasta AS DATE))
		)

	UNION ALL 
	
	/*********************** APLICACION ANTICIPO / CUENTAS POR COBRAR QUE SE REALIZAN EN EL DETALLE *********************/
	SELECT 'APLICACIÓN ANTICIPO'		Serie,
			''							Movimiento,
		   AAP.Documento				Documento,
		   AAP.FechaAplicacion			Fecha,
		   AAP.TipoCambio				TipoCambio,
		   TC.Nombre					TipoComprobante,
		   MO.CodigoSunat				Moneda,
		   CASE
				WHEN AAPD.IdDebeHaber = 1
					THEN
						CASE
							WHEN CC.IdMoneda = 1 AND AAP.IdMoneda = 1 THEN AAPD.TotalAplicado
							WHEN CC.IdMoneda = 2 AND AAP.IdMoneda = 1 THEN ROUND((AAPD.TotalAplicado/AAP.TipoCambio),2)
							WHEN CC.IdMoneda = 2 AND AAP.IdMoneda = 2 THEN AAPD.TotalAplicado
							WHEN CC.IdMoneda = 1 AND AAP.IdMoneda = 2 THEN ROUND((AAPD.TotalAplicado*AAP.TipoCambio),2)
						END
		   END							Haber,
		   CASE
				WHEN AAPD.IdDebeHaber = 2
					THEN
						CASE
							WHEN CC.IdMoneda = 1 AND AAP.IdMoneda = 1 THEN AAPD.TotalAplicado
							WHEN CC.IdMoneda = 2 AND AAP.IdMoneda = 1 THEN ROUND((AAPD.TotalAplicado/AAP.TipoCambio),2)
							WHEN CC.IdMoneda = 2 AND AAP.IdMoneda = 2 THEN AAPD.TotalAplicado
							WHEN CC.IdMoneda = 1 AND AAP.IdMoneda = 2 THEN ROUND((AAPD.TotalAplicado*AAP.TipoCambio),2)
						END	
		   END							Debe
	FROM ERP.AplicacionAnticipoCobrar AAP
	INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipoCobrar
	INNER JOIN ERP.CuentaCobrar CC ON CC.ID = AAPD.IdCuentaCobrar
	INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CC.IdTipoComprobante
	INNER JOIN Maestro.Moneda MO ON MO.ID = CC.IdMoneda
	WHERE CC.ID = @IdCuentaCobrar
	AND (
			(@TipoFecha = 1 AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE)) OR
			(@TipoFecha = 2 AND CAST(AAP.FechaAplicacion AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@FechaHasta AS DATE))
		)

	UNION ALL 

	/*********************** APLICACION ANTICIPO / CUENTAS POR COBRAR QUE SE REALIZAN EN LA CABECERA (ANTICIPO Y NOTA DE CRÉDITO) *********************/
	SELECT TC.Nombre				Serie,
			''						Movimiento,
		   AAPD.Documento			Documento,
		   AAPD.Fecha				Fecha,
		   AAP.TipoCambio			TipoCambio,
		   TC.Nombre				TipoComprobante,
		   MO.CodigoSunat			Moneda,
		   CASE
				WHEN AAPD.IdDebeHaber = 2 THEN AAPD.TotalAplicado    
		   END						Haber,
		   CASE
				WHEN AAPD.IdDebeHaber = 1 THEN AAPD.TotalAplicado    
		   END						Debe
	FROM ERP.AplicacionAnticipoCobrar AAP
	INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipoCobrar
	INNER JOIN ERP.CuentaCobrar CC ON CC.ID = AAP.IdCuentaCobrar
	INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = AAPD.IdTipoComprobante
	INNER JOIN Maestro.Moneda MO ON MO.ID = CC.IdMoneda
	WHERE CC.ID = @IdCuentaCobrar
	AND (
			(@TipoFecha = 1 AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE)) OR
			(@TipoFecha = 2 AND CAST(AAP.FechaAplicacion AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@FechaHasta AS DATE))
		)
	
	UNION ALL 
	
	/***********************AJUSTE *********************/
	SELECT TC.Nombre				Serie,
			''						Movimiento,
		   A.Documento				Documento,
		   A.Fecha					Fecha,
		   A.TipoCambio				TipoCambio,
		   TC.Nombre				TipoComprobante,
		   MO.CodigoSunat			Moneda,
		   CASE
				WHEN CC.IdDebeHaber = 1 THEN A.Total
		   END						Haber,
		   CASE
				WHEN CC.IdDebeHaber = 2 THEN A.Total
		   END						Debe
	FROM ERP.AjusteCuentaCobrar A
	INNER JOIN ERP.CuentaCobrar CC ON CC.ID = A.IdCuentaCobrar
	INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = A.IdTipoComprobante
	INNER JOIN Maestro.Moneda MO ON MO.ID = A.IdMoneda
	WHERE A.IdCuentaCobrar = @IdCuentaCobrar
	AND (
			(@TipoFecha = 1 AND CAST(A.Fecha AS DATE) <= CAST(@Fecha AS DATE)) OR
			(@TipoFecha = 2 AND CAST(A.Fecha AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@FechaHasta AS DATE))
		)
	END