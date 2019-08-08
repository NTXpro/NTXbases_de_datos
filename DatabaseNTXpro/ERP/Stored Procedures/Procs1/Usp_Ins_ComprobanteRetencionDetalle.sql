
CREATE PROCEDURE ERP.Usp_Ins_ComprobanteRetencionDetalle
@IdComprobanteRetencion INT,
@IdComprobante INT,
@IdSaldoInicial INT,
@Orden INT,
@MontoPagadoSoles DECIMAL(14, 5),
@MontoPagadoDolares DECIMAL(14, 5),
@MontoRetenidoSoles DECIMAL(14, 5),
@MontoRetenidoDolares DECIMAL(14, 5)
AS

	INSERT INTO ERP.ComprobanteRetencionDetalle
	(
		IdComprobanteRetencion,
		IdComprobante,
		IdSaldoInicial,
		Orden,
		MontoPagadoSoles,
		MontoPagadoDolares,
		MontoRetenidoSoles,
		MontoRetenidoDolares
	)
	VALUES
	(
		@IdComprobanteRetencion,
		@IdComprobante,
		@IdSaldoInicial,
		@Orden,
		@MontoPagadoSoles,
		@MontoPagadoDolares,
		@MontoRetenidoSoles,
		@MontoRetenidoDolares
	)
