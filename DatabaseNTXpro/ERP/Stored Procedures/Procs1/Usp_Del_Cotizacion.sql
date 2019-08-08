
CREATE PROC [ERP].[Usp_Del_Cotizacion] 
@ID			INT
AS
BEGIN
	DELETE FROM ERP.CotizacionReferencia WHERE IdCotizacion = @ID
	DELETE FROM ERP.CotizacionDetalle WHERE IdCotizacion = @ID
	DELETE FROM ERP.Cotizacion WHERE ID = @ID
END
