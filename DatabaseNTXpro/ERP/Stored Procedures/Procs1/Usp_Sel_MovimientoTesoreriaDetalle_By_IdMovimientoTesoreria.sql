CREATE PROC [ERP].[Usp_Sel_MovimientoTesoreriaDetalle_By_IdMovimientoTesoreria]
@IdMovimientoTesoreria INT
AS
BEGIN
	
	SELECT MTD.ID,
		   MTD.IdMovimientoTesoreria,
		   MTD.Orden,
		   MTD.IdPlanCuenta,
		   PC.CuentaContable,
		   MTD.IdProyecto,
		   P.Numero NumeroProyecto,
		   MTD.IdEntidad,
		   MTD.Nombre,
		   MTD.IdTipoComprobante,
		   TC.Nombre NombreTipoComprobante,
		   MTD.Serie,
		   MTD.Documento,
		   MTD.Total,
		   MTD.IdDebeHaber,
		   DH.Nombre NombreDebeHaber,
		   MTD.CodigoAuxiliar,
		   MT.TipoCambio,
		   CASE WHEN MTD.PagarCobrar = 'P' THEN
			MTDCP.IdCuentaPagar
		   ELSE
			MTDCC.IdCuentaCobrar
		   END IdCuentaCobrar,
		   PagarCobrar
	FROM ERP.MovimientoTesoreriaDetalle MTD
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
	LEFT JOIN ERP.Proyecto P ON P.ID = MTD.IdProyecto
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = MTD.IdPlanCuenta
	INNER JOIN Maestro.DebeHaber DH ON DH.ID = MTD.IdDebeHaber
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = MTD.IdTipoComprobante
	LEFT JOIN ERP.MovimientoTesoreriaDetalleCuentaCobrar MTDCC ON MTDCC.IdMovimientoTesoreriaDetalle = MTD.ID
	LEFT JOIN ERP.MovimientoTesoreriaDetalleCuentaPagar MTDCP ON MTDCP.IdMovimientoTesoreriaDetalle = MTD.ID
	WHERE IdMovimientoTesoreria = @IdMovimientoTesoreria

END