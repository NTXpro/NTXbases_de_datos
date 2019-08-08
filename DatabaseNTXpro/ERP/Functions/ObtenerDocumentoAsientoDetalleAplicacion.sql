CREATE FUNCTION ERP.ObtenerDocumentoAsientoDetalleAplicacion  (@IdAplicacionDetalle INT)
RETURNS VARCHAR(8)
AS
BEGIN

		DECLARE @DOCUMENTO VARCHAR(8) = (SELECT Documento FROM ERP.AplicacionAnticipoPagarDetalle WHERE ID = @IdAplicacionDetalle )

		RETURN @DOCUMENTO 
END
