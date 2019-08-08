
create PROC [ERP].[Usp_Del_Pedido] 
@ID			INT
AS
BEGIN
	DELETE FROM ERP.PedidoReferencia WHERE IdPedido = @ID
	DELETE FROM ERP.PedidoDetalle WHERE IdPedido = @ID
	DELETE FROM ERP.Pedido WHERE ID = @ID
END
