CREATE FUNCTION [ERP].[ObtenerCantidadTotalDetalleRequerimiento](@IdProducto INT,@IdRequerimiento INT)
RETURNS DECIMAL(14,5)
AS
BEGIN
DECLARE @TotalCantidad DECIMAL(14,5) = 0;
DECLARE @Table AS TABLE (ID INT, TotalCantidadPendiente DECIMAL(14,5))

INSERT INTO @Table
SELECT 
	OCR.ID,
	CASE WHEN RD.Cantidad > SUM(RD.Cantidad - (RD.Cantidad  - ISNULL(OCD.Cantidad,0))) OVER(ORDER BY OCR.ID) THEN
		(RD.Cantidad - SUM(RD.Cantidad - (RD.Cantidad  - ISNULL(OCD.Cantidad,0))) OVER(ORDER BY OCR.ID))
	ELSE
		(SUM(RD.Cantidad - (RD.Cantidad  - ISNULL(OCD.Cantidad,0))) OVER(ORDER BY OCR.ID) - RD.Cantidad)
	END AS TotalCantidadPendiente
FROM ERP.OrdenCompra OC
LEFT JOIN ERP.OrdenCompraReferencia OCR ON OCR.IdOrdenCompra = OC.ID
LEFT JOIN ERP.RequerimientoDetalle RD ON RD.IdRequerimiento = OCR.IdReferencia
LEFT JOIN ERP.OrdenCompraDetalle OCD ON OCD.IdOrdenCompra = OC.ID AND OCD.IdProducto = RD.IdProducto
WHERE OCR.FlagInterno = 1 AND OCR.IdReferenciaOrigen = 6 AND OC.IdOrdenCompraEstado != 2 AND OC.FlagBorrador = 0
AND (RD.IdProducto = @IdProducto OR OCD.IdProducto = @IdProducto) AND OCR.IdOrdenCompra IN (SELECT IdOrdenCompra FROM ERP.OrdenCompraReferencia WHERE IdReferencia = @IdRequerimiento)
--ORDER BY OCR.DOCUMENTO DESC
ORDER BY OCR.DOCUMENTO, OCR.ID DESC

--SET @TotalCantidad = (SELECT TOP 1 TotalCantidadPendiente FROM @Table);
SET @TotalCantidad = (SELECT TOP 1 TotalCantidadPendiente FROM @Table ORDER BY ID DESC);

RETURN @TotalCantidad
END