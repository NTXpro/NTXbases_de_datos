
create proc [ERP].[Usp_Sel_Report_RendirCuentaDetalle_By_IdRendirCuenta]
@IdRendirCuenta INT
AS
BEGIN
WITH ListaDetalle AS(
	SELECT 1 AS Orden,
		   PC.CuentaContable,
		   ''  CodigoAuxiliar,
		   '' Nombre,
		   '' TipoComprobante,
		   '' Serie,
		   '' Documento,
		   '' Proyecto,
		   	CAST(0 AS DECIMAL(14,5)) Debe,
			MRC.ToTalGastado Haber
	FROM ERP.MovimientoRendirCuenta MRC
	LEFT JOIN ERP.MovimientoTesoreria MT ON MT.ID = MRC.IdMovimientoTesoreria
	LEFT JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = C.IdPlanCuenta
	WHERE MRC.ID =  @IdRendirCuenta

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
	FROM ERP.MovimientoRendirCuentaDetalle MTD
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = MTD.IdPlanCuenta
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = MTD.IdTipoComprobante
	LEFT JOIN ERP.Proyecto P ON P.ID = MTD.IdProyecto
	WHERE MTD.IdMovimientoRendirCuenta = @IdRendirCuenta)

SELECT * FROM ListaDetalle ORDER BY Orden
END 