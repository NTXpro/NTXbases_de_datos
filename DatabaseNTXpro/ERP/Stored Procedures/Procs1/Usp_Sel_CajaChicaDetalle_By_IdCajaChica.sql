
CREATE PROC [ERP].[Usp_Sel_CajaChicaDetalle_By_IdCajaChica]
@IdMovimientoCajaChica INT
AS
BEGIN
	
	SELECT MCD.ID,
		   MCD.IdMovimientoCajaChica,
		   MCD.Orden,
		   MCD.IdCuenta,
		   C.Nombre NombreCuenta,
		   MCD.IdPlanCuenta,
		   PC.CuentaContable,
		   MCD.IdProyecto,
		   P.Numero NumeroProyecto,
		   MCD.IdEntidad,
		   MCD.Nombre,
		   MCD.IdTipoComprobante,
		   TC.Nombre NombreTipoComprobante,
		   MCD.Serie,
		   MCD.Documento,
		   MCD.Total,
		   MCD.IdDebeHaber,
		   DH.Nombre NombreDebeHaber,
		   MCD.CodigoAuxiliar,
		   MCC.TipoCambio,
		   MCD.IdCuentaPagar,
		   MCD.FlagTransferencia,
		   MCD.IdMovimientoTesoreria,
		   C.IdMoneda,
		   MCD.Operacion
	FROM ERP.MovimientoCajaChicaDetalle MCD
	INNER JOIN ERP.MovimientoCajaChica MCC ON MCC.ID = MCD.IdMovimientoCajaChica
	LEFT JOIN ERP.Proyecto P ON P.ID = MCD.IdProyecto
	LEFT JOIN ERP.Cuenta C ON C.ID = MCD.IdCuenta
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = MCD.IdPlanCuenta
	INNER JOIN Maestro.DebeHaber DH ON DH.ID = MCD.IdDebeHaber
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = MCD.IdTipoComprobante
	WHERE MCD.IdMovimientoCajaChica = @IdMovimientoCajaChica

END