CREATE PROCEDURE ERP.Usp_Sel_MovimientoTesoreriaDetalleById
@ID INT
AS
	SELECT  ID,
			IdMovimientoTesoreria,
			Orden,
			IdPlanCuenta,
			IdProyecto,
			IdEntidad,
			Nombre,
			IdTipoComprobante,
			Serie,
			Documento,
			Total,
			IdDebeHaber,
			CodigoAuxiliar,
			PagarCobrar
	FROM ERP.MovimientoTesoreriaDetalle
	WHERE ID = @ID
