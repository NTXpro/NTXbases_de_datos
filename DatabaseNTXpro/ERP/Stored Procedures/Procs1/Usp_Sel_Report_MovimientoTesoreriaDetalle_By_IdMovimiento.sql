CREATE proc [ERP].[Usp_Sel_Report_MovimientoTesoreriaDetalle_By_IdMovimiento]
@IdMovimiento INT
AS
BEGIN
WITH ListaDetalle AS(
	SELECT 1 AS Orden,
		   PC.CuentaContable,
		   ''  CodigoAuxiliar,
		   MT.Nombre,
		   '' TipoComprobante,
		   '' Serie,
		   Voucher Documento,
		   '' Proyecto,
		   	CASE WHEN MT.IdTipoMovimiento = 1 THEN
				MT.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END Debe,
			CASE WHEN MT.IdTipoMovimiento = 2 THEN
				MT.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END Haber
	FROM ERP.MovimientoTesoreria MT
	LEFT JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = C.IdPlanCuenta
	WHERE MT.ID =  @IdMovimiento

	UNION

	SELECT	2 AS Orden,
			PC.CuentaContable,
			MTD.CodigoAuxiliar,
			MTD.Nombre,
			TC.Abreviatura TipoComprobante,
			MTD.Serie,
			MTD.Documento,
			P.Numero Proyecto,
			CASE WHEN MTD.IdDebeHaber = 1 THEN
				MTD.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END Debe,
			CASE WHEN MTD.IdDebeHaber = 2 THEN
				MTD.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END Haber
	FROM ERP.MovimientoTesoreriaDetalle MTD
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = MTD.IdPlanCuenta
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = MTD.IdTipoComprobante
	LEFT JOIN ERP.Proyecto P ON P.ID = MTD.IdProyecto
	WHERE MTD.IdMovimientoTesoreria = @IdMovimiento)

SELECT * FROM ListaDetalle ORDER BY Orden
END 