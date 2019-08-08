CREATE FUNCTION ERP.ObtenerImporteAsientoDetalleCabeceraAplicacion (@IdAplicacion INT)
RETURNS DECIMAL (14,5)
AS
BEGIN

		DECLARE @Importe DECIMAL(14,5) = (SELECT SUM(TotalAplicado) FROM ERP.AplicacionAnticipoPagarDetalle AAPD
																	INNER JOIN ERP.AplicacionAnticipoPagar AAP
																	ON AAP.ID = AAPD.IdAplicacionAnticipo
																	WHERE AAP.ID = @IdAplicacion)
		RETURN ISNULL(@Importe,0)

END
