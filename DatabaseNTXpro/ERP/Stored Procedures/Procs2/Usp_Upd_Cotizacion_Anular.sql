
CREATE PROC [ERP].[Usp_Upd_Cotizacion_Anular] 
@ID			INT
AS
BEGIN
	UPDATE ERP.Cotizacion SET IdCotizacionEstado = 3 WHERE ID = @ID
END
