CREATE PROC [ERP].[Usp_Upd_Compra_EliminarBorrador]
@ID			INT
AS
BEGIN
	DELETE ERP.CompraDetalle WHERE IdCompra = @ID
	DELETE [ERP].[CompraReferenciaExterna] WHERE IdCompra = @ID
	DELETE [ERP].[CompraReferenciaInterna] WHERE IdCompra = @ID
	DELETE [ERP].[Compra] WHERE ID = @ID
	
END