
CREATE PROC [ERP].[Usp_Upd_Cotizacion_Emitir] 
@ID			INT
AS
BEGIN
	UPDATE ERP.Cotizacion SET IdCotizacionEstado = 2 WHERE ID = @ID
END
