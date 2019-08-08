
CREATE PROC [ERP].[Usp_Del_ValeTransferencia]
@ID INT
AS
BEGIN
	DELETE FROM ERP.ValeTransferenciaReferencia WHERE IdValeTransferencia = @ID	
	DELETE FROM ERP.ValeTransferenciaDetalle WHERE IdValeTransferencia = @ID	
	DELETE FROM ERP.ValeTransferencia WHERE ID = @ID
END
