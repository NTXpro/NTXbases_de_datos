CREATE PROC [ERP].[Usp_Sel_SituacionDocumentoDetalle]
@IdCuentaPagar INT,
@Fecha DATETIME,
@FechaHasta DATETIME,
@TipoFecha INT 
AS
BEGIN
SELECT
		ENTB.Nombre			Serie,
		MT.Orden			Movimiento,
		C.Nombre			Documento,
		MT.Fecha			Fecha,
		MT.TipoCambio		TipoCambio,
		TC.Nombre			TipoComprobante,
		MO.CodigoSunat		Moneda,
		CASE
			WHEN MTD.IdDebeHaber = 1
				THEN
					CASE
						WHEN CP.IdMoneda = 1 AND MT.IdMoneda = 1 THEN MTD.Total
						WHEN CP.IdMoneda = 2 AND MT.IdMoneda = 1 THEN ROUND((MTD.Total / MT.TipoCambio),2)
						WHEN CP.IdMoneda = 2 AND MT.IdMoneda = 2 THEN MTD.Total
						WHEN CP.IdMoneda = 1 AND MT.IdMoneda = 2 THEN ROUND((MTD.Total * MT.TipoCambio),2)
					END											
		END					Debe,
		CASE
			WHEN MTD.IdDebeHaber = 2
				THEN
					CASE
						WHEN CP.IdMoneda = 1 AND MT.IdMoneda = 1 THEN MTD.Total
						WHEN CP.IdMoneda = 2 AND MT.IdMoneda = 1 THEN ROUND((MTD.Total / MT.TipoCambio),2)
						WHEN CP.IdMoneda = 2 AND MT.IdMoneda = 2 THEN MTD.Total
						WHEN CP.IdMoneda = 1 AND MT.IdMoneda = 2 THEN ROUND((MTD.Total * MT.TipoCambio),2)
					END											
		END					Haber
FROM ERP.MovimientoTesoreriaDetalleCuentaPagar MTDCP
INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTDCP.IdMovimientoTesoreriaDetalle = MTD.ID
INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
INNER JOIN ERP.Entidad ENTB ON ENTB.ID = C.IdEntidad
INNER JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
INNER JOIN ERP.CuentaPagar CP ON CP.ID = MTDCP.IdCuentaPagar
INNER JOIN ERP.Entidad ENT ON ENT.ID = CP.IdEntidad
INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CP.IdTipoComprobante
INNER JOIN Maestro.Moneda MO ON MO.ID = CP.IdMoneda
WHERE CP.ID = @IdCuentaPagar
AND MT.Flag = 1 AND MT.FlagBorrador = 0
AND (
		(@TipoFecha = 1 AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE)) OR
		(@TipoFecha = 2 AND CAST(MT.Fecha AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@FechaHasta AS DATE))
	)

UNION ALL 

/*********************** APLICACION ANTICIPO / CUENTAS POR PAGAR QUE SE REALIZAN EN EL DETALLE *********************/
SELECT 'APLICACIÓN ANTICIPO'	Serie,
		''						Movimiento,
		AAP.Documento			Documento,
		AAP.FechaAplicacion		Fecha,
		AAP.TipoCambio			TipoCambio,
		TC.Nombre				TipoComprobante,
		MO.CodigoSunat			Moneda,
		CASE
			WHEN AAPD.IdDebeHaber = 2
				THEN
					CASE
						WHEN CP.IdMoneda = 1 AND AAP.IdMoneda = 1 THEN AAPD.TotalAplicado
						WHEN CP.IdMoneda = 2 AND AAP.IdMoneda = 1 THEN ROUND((AAPD.TotalAplicado/AAP.TipoCambio),2)
						WHEN CP.IdMoneda = 2 AND AAP.IdMoneda = 2 THEN AAPD.TotalAplicado
						WHEN CP.IdMoneda = 1 AND AAP.IdMoneda = 2 THEN ROUND((AAPD.TotalAplicado*AAP.TipoCambio),2)
					END
		END						Debe,
		CASE
			WHEN AAPD.IdDebeHaber = 1
				THEN
					CASE
						WHEN CP.IdMoneda = 1 AND AAP.IdMoneda = 1 THEN AAPD.TotalAplicado
						WHEN CP.IdMoneda = 2 AND AAP.IdMoneda = 1 THEN ROUND((AAPD.TotalAplicado/AAP.TipoCambio),2)
						WHEN CP.IdMoneda = 2 AND AAP.IdMoneda = 2 THEN AAPD.TotalAplicado
						WHEN CP.IdMoneda = 1 AND AAP.IdMoneda = 2 THEN ROUND((AAPD.TotalAplicado*AAP.TipoCambio),2)
					END
		END						Haber
FROM ERP.AplicacionAnticipoPagar AAP
INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAPD.IdCuentaPagar
INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CP.IdTipoComprobante
INNER JOIN Maestro.Moneda MO ON MO.ID = CP.IdMoneda
WHERE CP.ID = @IdCuentaPagar
AND (
		(@TipoFecha = 1 AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE)) OR
		(@TipoFecha = 2 AND CAST(AAP.FechaAplicacion AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@FechaHasta AS DATE))
	)

UNION ALL 

/*********************** APLICACION ANTICIPO / CUENTAS POR PAGAR QUE SE REALIZAN EN LA CABECERA (ANTICIPO Y NOTA DE CRÉDITO) *********************/
SELECT TC.Nombre				Serie,
		''						Movimiento,
		AAPD.Documento			Documento,
		AAPD.Fecha				Fecha,
		AAP.TipoCambio			TipoCambio,
		TC.Nombre				TipoComprobante,
		MO.CodigoSunat			Moneda,
		CASE
			WHEN AAPD.IdDebeHaber = 1
				THEN AAPD.TotalAplicado
		END						Deber,
		CASE
			WHEN AAPD.IdDebeHaber = 2
				THEN AAPD.TotalAplicado    
		END						Haber
FROM ERP.AplicacionAnticipoPagar AAP
INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAP.IdCuentaPagar
INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = AAPD.IdTipoComprobante
INNER JOIN Maestro.Moneda MO ON MO.ID = CP.IdMoneda
WHERE CP.ID = @IdCuentaPagar
AND (
		(@TipoFecha = 1 AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE)) OR
		(@TipoFecha = 2 AND CAST(AAP.FechaAplicacion AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@FechaHasta AS DATE))
	)
AND CP.IdTipoComprobante != 183
	
UNION ALL

/***********************AJUSTE *********************/
SELECT TC.Nombre				Serie,
		''						Movimiento,
		A.Documento				Documento,
		A.Fecha					Fecha,
		A.TipoCambio			TipoCambio,
		TC.Nombre				TipoComprobante,
		MO.CodigoSunat			Moneda,
		CASE
			WHEN CC.IdDebeHaber = 2
				THEN A.Total    
		END						Debe,
		CASE
			WHEN CC.IdDebeHaber = 1
				THEN A.Total    
		END						Haber
FROM ERP.AjusteCuentaPagar A
INNER JOIN ERP.CuentaPagar CC ON CC.ID = A.IdCuentaPagar
INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = A.IdTipoComprobante
INNER JOIN Maestro.Moneda MO ON MO.ID = A.IdMoneda
WHERE A.IdCuentaPagar = @IdCuentaPagar
AND (
		(@TipoFecha = 1 AND CAST(A.Fecha AS DATE) <= CAST(@Fecha AS DATE)) OR
		(@TipoFecha = 2 AND CAST(A.Fecha AS DATE) BETWEEN CAST(@Fecha AS DATE) AND CAST(@FechaHasta AS DATE))
	)
END