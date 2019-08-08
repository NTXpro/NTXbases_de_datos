CREATE FUNCTION [ERP].[ObtenerCantidadTotalDetalleOrdenCompra_Importacion](@IdProducto INT,@IdOrdenCompra INT)
RETURNS DECIMAL(14,5)
AS
BEGIN
	DECLARE @TotalCantidad DECIMAL(14,5) = 0;
	DECLARE @CantidadImportada DECIMAL(14, 5) = 0;

	SELECT @TotalCantidad = OCD.Cantidad
	FROM ERP.OrdenCompraDetalle OCD
	WHERE IdOrdenCompra = @IdOrdenCompra
	AND IdProducto = @IdProducto 

	SELECT @CantidadImportada = ISNULL(SUM(IPD.Cantidad), 0)
	FROM ERP.Importacion I
	--INNER JOIN ERP.ImportacionReferencia IR ON I.ID = IR.IdImportacion
	INNER JOIN ERP.ImportacionProductoDetalle IPD ON I.ID = IPD.IdImportacion
	WHERE IPD.IdOrdenCompra = @IdOrdenCompra
	AND IPD.IdProducto = @IdProducto
	AND ISNULL(I.FlagBorrador, 0) = 0
	--AND IR.FlagInterno = 1 
	--AND IR.IdReferenciaOrigen = 7 
	--AND I.IdImportacionEstado != 3 
	
	
	RETURN @TotalCantidad - @CantidadImportada
END