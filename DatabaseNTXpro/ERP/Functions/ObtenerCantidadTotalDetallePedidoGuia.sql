
CREATE FUNCTION [ERP].[ObtenerCantidadTotalDetallePedidoGuia](@IdProducto INT,@IdPedido INT)
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
FROM ERP.GuiaRemision OC
LEFT JOIN ERP.GuiaRemisionReferencia OCR ON OCR.IdGuiaRemision = OC.ID
LEFT JOIN ERP.Pedido P ON P.ID = OCR.IdReferencia
LEFT JOIN ERP.PedidoDetalle RD ON RD.IdPedido = OCR.IdReferencia
LEFT JOIN ERP.GuiaRemisionDetalle OCD ON OCD.IdGuiaRemision = OC.ID AND OCD.IdProducto = RD.IdProducto
WHERE OCR.FlagInterno = 1 AND OCR.IdReferenciaOrigen = 9 AND OC.IdGuiaRemisionEstado != 3 AND OC.FlagBorrador = 0
AND (RD.IdProducto = @IdProducto OR OCD.IdProducto = @IdProducto) AND OCR.IdGuiaRemision IN (SELECT IdGuiaRemision FROM ERP.GuiaRemisionReferencia WHERE IdReferencia = @IdPedido)
ORDER BY OCR.DOCUMENTO DESC

SET @TotalCantidad = ISNULL((SELECT TOP 1 TotalCantidadPendiente FROM @Table), 0);

RETURN @TotalCantidad
END