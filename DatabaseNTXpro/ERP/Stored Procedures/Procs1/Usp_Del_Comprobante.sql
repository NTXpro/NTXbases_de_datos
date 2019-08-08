
CREATE PROC [ERP].[Usp_Del_Comprobante] 
@IdComprobante			INT
AS
BEGIN
	EXEC [ERP].[Usp_Upd_Comprobante_Anular] @IdComprobante,0,'',''
	DELETE FROM ERP.ComprobanteCuentaCobrar WHERE IdComprobante = @IdComprobante
	DELETE FROM ERP.CuentaCobrar WHERE ID IN (SELECT IdCuentaCobrar FROM ERP.ComprobanteCuentaCobrar  WHERE IdComprobante = @IdComprobante)
	DELETE FROM ERP.ComprobanteReferencia WHERE IdComprobante = @IdComprobante
	DELETE FROM ERP.ComprobanteReferenciaExterno WHERE IdComprobante = @IdComprobante
	DELETE FROM ERP.ComprobanteReferenciaInterno WHERE IdComprobante = @IdComprobante
	DELETE FROM ERP.ComprobanteDetalle WHERE IdComprobante = @IdComprobante
	DELETE FROM ERP.Comprobante WHERE ID = @IdComprobante
END
