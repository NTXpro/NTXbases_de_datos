CREATE PROC ERP.Usp_Calculo_Requerimiento
AS
BEGIN
DECLARE @IdProducto INT = 1;
DECLARE @IdRequerimiento INT = 3;

DECLARE @Documento VARCHAR(20) = (SELECT DISTINCT Documento FROM ERP.OrdenCompraReferencia WHERE IdReferencia = @IdRequerimiento)

SELECT rd.ID,
		OCD.id,
		RD.Cantidad cantidadrequerimiento, 
		OCD.Cantidad cantidadorden,
		SUM(ISNULL(OCD.Cantidad,0)) OVER(ORDER BY OCR.ID) AS SUMOCDCANTIDAD,
		RD.Cantidad - SUM((ISNULL(OCD.Cantidad,0))) OVER(ORDER BY OCR.ID) SALDONULO,
		CASE WHEN RD.Cantidad < SUM(ISNULL(OCD.Cantidad,0)) OVER(ORDER BY OCR.ID) THEN
			0
		ELSE
			RD.Cantidad - SUM((ISNULL(OCD.Cantidad,0))) OVER(ORDER BY OCR.ID) 
		END AS saldo
FROM [ERP].[OrdenCompraReferencia] OCR
LEFT JOIN ERP.Requerimiento R ON R.ID = OCR.IdReferencia
LEFT JOIN ERP.RequerimientoDetalle RD ON RD.IdRequerimiento = R.ID
LEFT JOIN ERP.OrdenCompraDetalle OCD ON OCD.IdOrdenCompra = OCR.IdOrdenCompra AND OCD.IdProducto = RD.IdProducto
WHERE OCR.IdReferencia IN 
(SELECT OCRREF.IdReferencia 
 FROM ERP.OrdenCompraReferencia OCRREF
 WHERE OCRREF.IdOrdenCompra IN (SELECT OCROC.IdOrdenCompra FROM ERP.OrdenCompraReferencia OCROC WHERE OCROC.IdReferencia = @IdRequerimiento))
 AND (OCD.IdProducto = @IdProducto OR RD.IdProducto = @IdProducto) AND OCR.Documento <= @Documento
 END
