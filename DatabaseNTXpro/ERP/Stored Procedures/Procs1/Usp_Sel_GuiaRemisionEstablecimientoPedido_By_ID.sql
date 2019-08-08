CREATE PROC [ERP].[Usp_Sel_GuiaRemisionEstablecimientoPedido_By_ID]
@IdGuiaRemision INT 
AS
BEGIN

        SELECT
        E.Nombre EstablecimientoCliente, CONCAT(T10.Abreviatura, '-', PR.Documento) Referencia
        FROM ERP.GuiaRemision GR
        INNER JOIN ERP.GuiaRemisionReferencia GRR ON GRR.IdGuiaRemision = GR.ID
        INNER JOIN ERP.Pedido P ON P.ID = GRR.IdReferencia
        INNER JOIN ERP.PedidoReferencia PR ON PR.IdPedido = P.ID
        INNER JOIN PLE.T10TipoComprobante T10 ON T10.ID = PR.IdTipoComprobante
        INNER JOIN ERP.Establecimiento E ON E.ID = P.IdEstablecimientoCliente
        WHERE GR.ID = @IdGuiaRemision
        
END