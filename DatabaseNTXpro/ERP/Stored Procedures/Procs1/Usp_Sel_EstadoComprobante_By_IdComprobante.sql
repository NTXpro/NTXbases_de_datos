CREATE PROC ERP.Usp_Sel_EstadoComprobante_By_IdComprobante
@IdComprobante INT
AS
BEGIN
	
	DECLARE @IdComprobanteEstado INT = (SELECT IdComprobanteEstado FROM ERP.Comprobante WHERE ID = @IdComprobante) 

	SELECT @IdComprobanteEstado
END