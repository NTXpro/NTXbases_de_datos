
CREATE PROC [ERP].[Usp_Del_Producto]
@IdProducto		INT
AS
BEGIN
		DELETE FROM ERP.FamiliaProducto WHERE IdProducto = @IdProducto
		DELETE FROM ERP.ListaPrecioDetalle WHERE IdProducto = @IdProducto
		DELETE FROM ERP.Producto WHERE ID = @IdProducto
		
END
