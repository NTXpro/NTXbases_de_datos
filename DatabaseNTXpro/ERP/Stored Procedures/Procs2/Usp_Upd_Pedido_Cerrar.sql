
CREATE PROC [ERP].[Usp_Upd_Pedido_Cerrar]
@ID			INT
AS
BEGIN
	UPDATE ERP.Pedido 
	SET IdPedidoEstado = 6
	WHERE ID = @ID
END