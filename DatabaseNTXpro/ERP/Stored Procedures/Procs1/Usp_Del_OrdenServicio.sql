
CREATE PROC [ERP].[Usp_Del_OrdenServicio]
@ID INT
AS
BEGIN
	DELETE FROM ERP.OrdenServicioReferencia WHERE IdOrdenServicio = @ID
	DELETE FROM ERP.OrdenServicioDetalle WHERE IdOrdenServicio = @ID
	DELETE FROM ERP.OrdenServicio WHERE ID = @ID
END