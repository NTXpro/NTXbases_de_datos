CREATE FUNCTION ERP.ObtenerSerieAsientoDetalleAplicacionCobrar  (@IdAplicacionDetalle INT)
RETURNS VARCHAR(4)
AS
BEGIN

		DECLARE @SERIE VARCHAR(4) = (SELECT Serie FROM ERP.AplicacionAnticipoCobrarDetalle WHERE ID = @IdAplicacionDetalle )

		RETURN @SERIE 
END
