CREATE FUNCTION [ERP].[ObtenerCantidadTotalDetalleOrdenCompra](@IdProducto INT,@IdOrdenCompra INT)
RETURNS DECIMAL(14,5)
AS
BEGIN
DECLARE @TableReferencias AS TABLE(IdPadre INT,IdReferencia INT, Tipo INT);
----------------------------SE UNEN LAS REFERENCIAS
INSERT INTO @TableReferencias (IdPadre, IdReferencia, Tipo)
SELECT V.ID, VR.IdReferencia, 1 AS Tipo    
FROM ERP.ValeReferencia VR
INNER JOIN ERP.Vale V ON V.ID = VR.IdVale
WHERE V.IdValeEstado != 2 AND VR.IdReferencia = @IdOrdenCompra AND VR.IdReferenciaOrigen = 7 AND VR.FlagInterno = 1 AND V.FlagBorrador = 0
UNION
SELECT I.ID, IR.IdReferencia, 2 AS Tipo   
FROM ERP.ImportacionReferencia IR
INNER JOIN ERP.Importacion I ON I.ID = IR.IdImportacion
WHERE I.IdImportacionEstado != 3 AND IR.IdReferencia = @IdOrdenCompra AND IR.IdReferenciaOrigen = 7  AND IR.FlagInterno = 1;

----------------------------SE UNE EL DETALLE DE LAS REFERENCIAS
DECLARE @TableDetalle AS TABLE(IdPadre INT,IdProducto INT,Cantidad DECIMAL(14,5), Tipo INT);
INSERT INTO @TableDetalle(IdPadre,IdProducto,Cantidad, Tipo)
SELECT IdVale, IdProducto, Cantidad, 1 
FROM ERP.ValeDetalle 
WHERE IdVale IN (SELECT IdPadre FROM @TableReferencias where Tipo = 1)
UNION
SELECT IdImportacion, IdProducto, SUM(Cantidad), 2 
FROM ERP.ImportacionProductoDetalle 
WHERE IdImportacion IN (SELECT IdPadre FROM @TableReferencias where Tipo = 2)
GROUP BY IdImportacion,IdProducto

DECLARE @TotalCantidad DECIMAL(14,5) = 0;
DECLARE @Table AS TABLE (ID INT, TotalCantidadPendiente DECIMAL(14,5))

INSERT INTO @Table
SELECT 
	OCR.IdPadre,
	CASE WHEN RD.Cantidad > SUM(RD.Cantidad - (RD.Cantidad  - ISNULL(OCD.Cantidad,0))) OVER(ORDER BY OCR.IdPadre) THEN
		(RD.Cantidad - SUM(RD.Cantidad - (RD.Cantidad  - ISNULL(OCD.Cantidad,0))) OVER(ORDER BY OCR.IdPadre))
	ELSE
		(SUM(RD.Cantidad - (RD.Cantidad  - ISNULL(OCD.Cantidad,0))) OVER(ORDER BY OCR.IdPadre) - RD.Cantidad)
	END AS TotalCantidadPendiente
FROM @TableReferencias OCR 
LEFT JOIN ERP.OrdenCompraDetalle RD ON RD.IdOrdenCompra = OCR.IdReferencia
LEFT JOIN @TableDetalle OCD ON OCD.IdPadre = OCR.IdPadre AND OCD.IdProducto = RD.IdProducto AND OCD.Tipo = OCR.Tipo
WHERE (RD.IdProducto = @IdProducto OR OCD.IdProducto = @IdProducto)
ORDER BY OCR.IdPadre DESC

SET @TotalCantidad = (SELECT TOP 1 TotalCantidadPendiente FROM @Table ORDER BY ID DESC);

RETURN @TotalCantidad
END