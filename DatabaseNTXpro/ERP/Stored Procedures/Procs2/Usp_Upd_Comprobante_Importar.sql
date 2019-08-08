CREATE PROC ERP.Usp_Upd_Comprobante_Importar
@IdComprobante INT,
@IdComprobanteEstado INT
AS
BEGIN
		UPDATE ERP.Comprobante SET IdComprobanteEstado = @IdComprobanteEstado WHERE ID = @IdComprobante
END
