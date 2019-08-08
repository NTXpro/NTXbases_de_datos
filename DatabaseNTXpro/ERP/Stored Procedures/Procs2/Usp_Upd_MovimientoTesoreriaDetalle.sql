
CREATE PROCEDURE ERP.Usp_Upd_MovimientoTesoreriaDetalle
@ID INT,
@IdMovimientoTesoreria INT,
@IdPlanCuenta INT,
@IdProyecto INT,
@Orden INT,
@IdEntidad INT,
@Nombre VARCHAR(250),
@IdTipoComprobante INT,
@Serie VARCHAR(4),
@Documento VARCHAR(20),
@Total DECIMAL(14,5),
@IdDebeHaber INT,
@CodigoAuxiliar VARCHAR(50),
@PagarCobrar CHAR(1)
AS
	UPDATE ERP.MovimientoTesoreriaDetalle
	SET	IdMovimientoTesoreria = @IdMovimientoTesoreria,
		IdPlanCuenta = @IdPlanCuenta,
		IdProyecto = @IdProyecto,
		Orden = @Orden,		
		IdEntidad = @IdEntidad,
		Nombre = @Nombre,
		IdTipoComprobante = @IdTipoComprobante,
		Serie = @Serie,
		Documento = @Documento,
		Total = @Total,
		IdDebeHaber = @IdDebeHaber,		
		CodigoAuxiliar = @CodigoAuxiliar,
		PagarCobrar = @PagarCobrar
	WHERE ID = @ID
