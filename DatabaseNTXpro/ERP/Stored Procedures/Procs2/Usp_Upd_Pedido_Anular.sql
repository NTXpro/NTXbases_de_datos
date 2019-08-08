

CREATE PROC [ERP].[Usp_Upd_Pedido_Anular] 
@ID			INT
AS
BEGIN
	UPDATE ERP.Pedido SET IdPedidoEstado = 3 WHERE ID = @ID
END
