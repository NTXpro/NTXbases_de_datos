
CREATE PROCEDURE [ERP].[Usp_Validar_Transformacion_Creada_Por_Boleta] 
@IdTransformacion INT
AS
BEGIN
	SELECT count( cd.IdComprobante)
FROM ERP.ComprobanteDetalle cd
     INNER JOIN ERP.Comprobante c ON cd.IdComprobante = c.ID
     LEFT JOIN ERP.Transformacion t ON c.SerieDocumentoComprobante = SUBSTRING(T.Observaciones, 1, 13)
WHERE cd.IdProducto IN
(
    SELECT r.IdProducto
    FROM ERP.Receta r
)AND t.ID = @IdTransformacion
END