
CREATE PROC [ERP].[Usp_Upd_Comprobante_Anular]
@IdComprobante INT,
@CorrelativoAnulacionSunat INT,
@UsuarioAnulo VARCHAR(250),
@TicketAnulacion VARCHAR(250)
AS
BEGIN
	DECLARE @IdAsiento INT = (SELECT IdAsiento FROM ERP.Comprobante WHERE ID = @IdComprobante)
	DECLARE @IdVale INT = (SELECT IdVale FROM ERP.Comprobante WHERE ID = @IdComprobante)

	EXEC [ERP].[Usp_Upd_Vale_Anular] @IdVale

	UPDATE ERP.Comprobante SET IdComprobanteEstado = 3,CorrelativoAnulacionSunat = @CorrelativoAnulacionSunat, TicketAnulacion = @TicketAnulacion,FechaAnulado = GETDATE(), UsuarioAnulo = @UsuarioAnulo   WHERE ID = @IdComprobante

	UPDATE ERP.CuentaCobrar SET Flag = 0 WHERE ID IN (SELECT IdCuentaCobrar FROM [ERP].[ComprobanteCuentaCobrar] WHERE IdComprobante = @IdComprobante)

	UPDATE ERP.GuiaRemision SET IdGuiaRemisionEstado = 2 
	WHERE ID IN (SELECT IdReferencia FROM ERP.ComprobanteReferencia WHERE IdComprobante = @IdComprobante AND IdReferenciaOrigen = 3);

	UPDATE ERP.Pedido SET IdPedidoEstado = 2 
	WHERE ID IN (SELECT IdReferencia FROM ERP.ComprobanteReferencia WHERE IdComprobante = @IdComprobante AND IdReferenciaOrigen = 9);

	EXEC [ERP].[Usp_Upd_AsientoContable_Venta_Anulado] @IdAsiento

	EXEC [ERP].[Usp_Upd_Transformacion_Anular_Por_Comprobante] @IdComprobante
END