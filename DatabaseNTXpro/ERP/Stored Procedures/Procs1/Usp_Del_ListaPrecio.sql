CREATE PROC ERP.Usp_Del_ListaPrecio
@ID INT
AS
BEGIN
	
	DELETE FROM ERP.ListaPrecioDetalle WHERE IdListaPrecio = @ID
	DELETE FROM ERP.ListaPrecio WHERE ID = @ID

END