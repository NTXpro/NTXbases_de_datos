CREATE PROCEDURE ERP.spu_Obtener_Referencia_Orden_Compra_Reporte
       @ID [int]
AS
   SET NOCOUNT ON
   SET XACT_ABORT ON
   BEGIN TRANSACTION

SELECT CASE WHEN (tc.id IN(165,201)) THEN (UPPER(tc.Abreviatura)+'-'+cr.Documento+' ') ELSE (UPPER(tc.Abreviatura)+'-'+ [cr].Serie +'-'+cr.Documento+' ') END AS REFERENCIA
FROM [ERP].[ComprobanteReferencia] cr
    LEFT JOIN PLE.T10TipoComprobante tc ON cr.IdTipoComprobante = tc.ID
WHERE cr.IdComprobante = @ID

   COMMIT