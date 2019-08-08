CREATE PROC [ERP].[Usp_Del_GuiaRemision]
@IdGuiaRemision INT
AS
BEGIN
		DELETE FROM ERP.ValeDetalle WHERE IdVale IN (SELECT IdVale FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision)
		DELETE FROM ERP.Vale WHERE ID IN (SELECT IdVale FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision)
		DELETE FROM ERP.GuiaRemisionReferencia WHERE ID = @IdGuiaRemision
		DELETE FROM ERP.GuiaRemisionDetalle WHERE IdGuiaRemision = @IdGuiaRemision
		DELETE FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision
	
END