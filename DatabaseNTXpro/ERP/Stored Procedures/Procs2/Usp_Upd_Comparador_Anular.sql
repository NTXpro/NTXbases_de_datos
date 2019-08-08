
CREATE PROCEDURE [ERP].[Usp_Upd_Comparador_Anular]
@ID	 INT
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		
		UPDATE ERP.Comparador SET Flag = 0 WHERE ID = @ID

		UPDATE ERP.OrdenCompra SET IdOrdenCompraEstado = 2 WHERE
		ID IN (SELECT IdOrdenCompra FROM ERP.OrdenCompraReferencia WHERE IdReferencia = @ID AND IdReferenciaOrigen = 12)

		SET NOCOUNT OFF;
END