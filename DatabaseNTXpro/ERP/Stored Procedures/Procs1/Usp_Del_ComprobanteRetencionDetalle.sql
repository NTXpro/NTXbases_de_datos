
CREATE PROCEDURE ERP.Usp_Del_ComprobanteRetencionDetalle
@IdComprobanteRetencion INT
AS
	DELETE FROM ERP.ComprobanteRetencionDetalle
	WHERE IdComprobanteRetencion = @IdComprobanteRetencion
