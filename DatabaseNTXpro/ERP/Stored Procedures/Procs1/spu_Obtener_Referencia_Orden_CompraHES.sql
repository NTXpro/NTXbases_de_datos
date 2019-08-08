CREATE PROCEDURE ERP.spu_Obtener_Referencia_Orden_CompraHES
       @ID [int]
AS
   SET NOCOUNT ON
   SET XACT_ABORT ON
   
   BEGIN TRANSACTION

SELECT
     (upper(tc.Abreviatura) + '-'+ [Documento]) AS REFERENCIA
 
 FROM [ERP].[ComprobanteReferencia] cr
 LEFT JOIN PLE.T10TipoComprobante tc ON cr.IdTipoComprobante = tc.ID
 WHERE cr.IdComprobante=@ID AND tc.id=201

   COMMIT
/**/