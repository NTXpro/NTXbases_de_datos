CREATE proc [ERP].[Usp_Sel_Report_CajaChicaDetalle_By_IdCajaChica]
@IdCajaChica INT
AS
BEGIN
WITH ListaDetalle AS(
	SELECT 1 AS Orden,
		   PC.CuentaContable,
		   ''  CodigoAuxiliar,
		   MCC.Observacion Nombre,
		   '' TipoComprobante,
		   '' Serie,
		   MCC.Documento Documento,
		   '' Proyecto,
		   	CAST(0 AS DECIMAL(14,5)) Debe,
			MCC.TotalGastado Haber
	FROM ERP.MovimientoCajaChica MCC
	LEFT JOIN ERP.Cuenta C ON C.ID = MCC.IdCuenta
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = C.IdPlanCuenta
	WHERE MCC.ID =  @IdCajaChica

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
	FROM ERP.MovimientoCajaChicaDetalle MTD
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = MTD.IdPlanCuenta
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = MTD.IdTipoComprobante
	LEFT JOIN ERP.Proyecto P ON P.ID = MTD.IdProyecto
	WHERE MTD.IdMovimientoCajaChica = @IdCajaChica)

SELECT * FROM ListaDetalle ORDER BY Orden
END
