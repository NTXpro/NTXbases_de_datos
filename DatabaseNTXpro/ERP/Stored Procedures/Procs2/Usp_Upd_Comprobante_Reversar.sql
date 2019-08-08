CREATE PROC [ERP].[Usp_Upd_Comprobante_Reversar]
@IdComprobante INT
AS
BEGIN
	EXEC [ERP].[Usp_Upd_Comprobante_Anular] @IdComprobante,0,'',''

	UPDATE ERP.Comprobante SET IdComprobanteEstado = 1, IdAsiento = NULL WHERE ID = @IdComprobante
END
