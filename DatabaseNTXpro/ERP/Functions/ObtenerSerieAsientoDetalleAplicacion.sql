CREATE FUNCTION ERP.ObtenerSerieAsientoDetalleAplicacion  (@IdAplicacionDetalle INT)
RETURNS VARCHAR(4)
AS
BEGIN

		DECLARE @SERIE VARCHAR(4) = (SELECT Serie FROM ERP.AplicacionAnticipoPagarDetalle WHERE ID = @IdAplicacionDetalle )

		RETURN @SERIE 
END
