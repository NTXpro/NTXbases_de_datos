CREATE PROC [ERP].[Usp_Upd_Pedido_Emitir] 
@ID			INT
AS
BEGIN
	UPDATE ERP.Pedido SET IdPedidoEstado = 2 WHERE ID = @ID
END
