
CREATE PROCEDURE ERP.Usp_Del_ComprobanteRetencion
@IdComprobanteRetencion INT
AS
	DELETE FROM ERP.ComprobanteRetencionDetalle
	WHERE IdComprobanteRetencion = @IdComprobanteRetencion

	DELETE FROM ERP.ComprobanteRetencion
	WHERE ID = @IdComprobanteRetencion
