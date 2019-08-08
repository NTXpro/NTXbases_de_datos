CREATE PROC ERP.Usp_Upd_OrdenCompra_Anular
@ID INT
AS
BEGIN
	UPDATE ERP.OrdenCompra SET IdOrdenCompraEstado = 2 WHERE ID = @ID
END
