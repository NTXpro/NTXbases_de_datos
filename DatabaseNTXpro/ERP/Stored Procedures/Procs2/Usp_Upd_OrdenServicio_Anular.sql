
CREATE PROC [ERP].[Usp_Upd_OrdenServicio_Anular]
@ID INT
AS
BEGIN
	UPDATE ERP.OrdenServicio SET IdOrdenServicioEstado = 2 WHERE ID = @ID
END