CREATE FUNCTION [ERP].[ObtenerImporteAsientoDetalleCabeceraAplicacionCobrar] (@IdAplicacion INT)
RETURNS DECIMAL (14,5)
AS
BEGIN
		DECLARE @Importe DECIMAL(14,5) = (SELECT SUM(TotalAplicado) FROM ERP.AplicacionAnticipoCobrarDetalle AACD
																	INNER JOIN ERP.AplicacionAnticipoCobrar AAC
																	ON AAC.ID = AACD.IdAplicacionAnticipoCobrar
																	WHERE AAC.ID = @IdAplicacion)

		RETURN ISNULL(@Importe,0)

END
