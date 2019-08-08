

CREATE PROC [ERP].[Usp_Sel_RendirCuentaDetalle_By_IdRendirCuenta]
@IdRendirCuenta INT
AS
BEGIN
	
	SELECT MRCD.ID,
		   MRCD.IdMovimientoRendirCuenta,
		   MRCD.Orden,
		   MRCD.IdCuenta,
		   C.Nombre NombreCuenta,
		   MRCD.IdPlanCuenta,
		   PC.CuentaContable,
		   MRCD.IdProyecto,
		   P.Numero NumeroProyecto,
		   MRCD.IdEntidad,
		   MRCD.Nombre,
		   MRCD.IdTipoComprobante,
		   TC.Nombre NombreTipoComprobante,
		   MRCD.Serie,
		   MRCD.Documento,
		   MRCD.Total,
		   MRCD.IdDebeHaber,
		   DH.Nombre NombreDebeHaber,
		   MRCD.CodigoAuxiliar,
		   MT.TipoCambio,
		   MRCD.IdCuentaPagar,
		   MRCD.FlagTransferencia,
		   MRCD.IdMovimientoTesoreria,
		   C.IdMoneda,
		   MRCD.Operacion
	FROM ERP.MovimientoRendirCuentaDetalle MRCD
	INNER JOIN ERP.MovimientoRendirCuenta MRC ON MRC.ID = MRCD.IdMovimientoRendirCuenta
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MRC.IdMovimientoTesoreria
	LEFT JOIN ERP.Proyecto P ON P.ID = MRCD.IdProyecto
	LEFT JOIN ERP.Cuenta C ON C.ID = MRCD.IdCuenta
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = MRCD.IdPlanCuenta
	LEFT JOIN Maestro.DebeHaber DH ON DH.ID = MRCD.IdDebeHaber
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = MRCD.IdTipoComprobante
	WHERE MRCD.IdMovimientoRendirCuenta = @IdRendirCuenta

END
