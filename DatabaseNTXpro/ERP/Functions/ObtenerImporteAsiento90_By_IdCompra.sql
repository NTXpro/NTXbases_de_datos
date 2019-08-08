CREATE FUNCTION ERP.ObtenerImporteAsiento90_By_IdCompra(@IdDetalleCompra INT)
RETURNS DECIMAL(14,5)
AS 
BEGIN

	DECLARE @ImporteAsiento90 DECIMAL(14,5) = (SELECT Importe FROM ERP.CompraDetalle WHERE ID = @IdDetalleCompra )

	RETURN ISNULL(@ImporteAsiento90,0)
END
