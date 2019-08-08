CREATE PROCEDURE ERP.spu_Obtener_Referencia_Orden_Compra_HES
        @ID [int]
AS
    SET NOCOUNT ON
    SET XACT_ABORT ON
    
    BEGIN TRANSACTION

SELECT 
      (upper(tc.Abreviatura) + '-0'+ [Serie]+ '-'+ [Documento]) AS REFERENCIA
  
  FROM [DB_A10D2A_ERPITS].[ERP].[ComprobanteReferencia] cr
  LEFT JOIN PLE.T10TipoComprobante tc ON cr.IdTipoComprobante = tc.ID
  WHERE cr.IdComprobante=@ID AND tc.id=201

    COMMIT