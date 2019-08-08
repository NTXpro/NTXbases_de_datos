
CREATE FUNCTION ERP.ObtenerDocumentoAsientoDetalleAplicacionCobrar  (@IdAplicacionDetalle INT)
RETURNS VARCHAR(8)
AS
BEGIN

		DECLARE @DOCUMENTO VARCHAR(8) = (SELECT Documento FROM ERP.AplicacionAnticipoCobrarDetalle WHERE ID = @IdAplicacionDetalle )

		RETURN @DOCUMENTO 
END
