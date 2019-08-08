CREATE FUNCTION ERP.ObtenerImporteAsientoDetalleAplicacion (@IdAplicacionDetalle INT)
RETURNS DECIMAL (14,5)
AS
BEGIN
		DECLARE @Importe DECIMAL(14,5) = (SELECT TotalAplicado FROM ERP.AplicacionAnticipoPagarDetalle WHERE ID = @IdAplicacionDetalle )
		RETURN ISNULL(@Importe,0)
END 

