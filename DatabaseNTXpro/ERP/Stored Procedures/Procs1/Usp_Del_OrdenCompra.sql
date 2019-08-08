CREATE PROC ERP.Usp_Del_OrdenCompra
@ID INT
AS
BEGIN
	DELETE FROM ERP.OrdenCompraReferencia WHERE IdOrdenCompra = @ID
	DELETE FROM ERP.OrdenCompraDetalle WHERE IdOrdenCompra = @ID
	DELETE FROM ERP.OrdenCompra WHERE ID = @ID
END
