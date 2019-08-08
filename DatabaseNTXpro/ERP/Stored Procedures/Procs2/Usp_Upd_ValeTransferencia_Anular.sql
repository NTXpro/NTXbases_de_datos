
CREATE PROC [ERP].[Usp_Upd_ValeTransferencia_Anular]
@ID INT
AS
BEGIN
	DECLARE @IdValeOrigen INT = (SELECT IdValeOrigen FROM ERP.ValeTransferencia WHERE ID = @ID);
	DECLARE @IdValeDestino INT = (SELECT IdValeDestino FROM ERP.ValeTransferencia WHERE ID = @ID);

	EXEC [ERP].[Usp_Upd_Vale_Anular] @IdValeOrigen
	EXEC [ERP].[Usp_Upd_Vale_Anular] @IdValeDestino

	UPDATE ERP.ValeTransferencia SET Flag = 0 WHERE ID = @ID
END
