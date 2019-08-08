
CREATE PROCEDURE ERP.Usp_Ins_MovimientoTesoreriaDetalle
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
@PagarCobrar CHAR(1),
@IdCuentaCobrar INT,
@ID INT OUTPUT
AS
	INSERT INTO ERP.MovimientoTesoreriaDetalle
	(	
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
	)
	VALUES 
	(
		@IdMovimientoTesoreria,
		@Orden,
		@IdPlanCuenta,
		@IdProyecto,		
		@IdEntidad,
		@Nombre,
		@IdTipoComprobante,
		@Serie,
		@Documento,
		@Total,
		@IdDebeHaber,
		@CodigoAuxiliar,
		@PagarCobrar
	)

	SET @ID = SCOPE_IDENTITY()

	IF @IdCuentaCobrar > 0 
	BEGIN
		
		IF @PagarCobrar = 'P'
			BEGIN
				INSERT INTO ERP.MovimientoTesoreriaDetalleCuentaPagar(IdCuentaPagar, IdMovimientoTesoreriaDetalle)
				VALUES(@IdCuentaCobrar, @ID);
			END
		ELSE 
			BEGIN
				INSERT INTO ERP.MovimientoTesoreriaDetalleCuentaCobrar(IdCuentaCobrar, IdMovimientoTesoreriaDetalle)
				VALUES(@IdCuentaCobrar, @ID)
			END
	END	
