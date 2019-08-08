CREATE PROC [ERP].[Usp_Sel_PedidoDetalleImportadoParcialGuia_By_IdPedido] --2
@IdPedido INT
AS
BEGIN

DECLARE @IdGuiaRemision INT = (SELECT TOP 1 OCR.IdGuiaRemision 
								FROM ERP.GuiaRemisionReferencia OCR 
								INNER JOIN ERP.GuiaRemision C ON C.ID = OCR.IdGuiaRemision
								WHERE OCR.IdReferencia = @IdPedido AND OCR.FlagInterno = 1 AND OCR.IdReferenciaOrigen = 9 AND C.FlagBorrador = 0 AND C.IdGuiaRemisionEstado != 2)

SELECT PD.ID
      ,PD.IdPedido
      ,PD.IdProducto
      ,PD.Nombre
      ,CASE WHEN @IdGuiaRemision IS NULL THEN
		 PD.Cantidad
	  ELSE
	  (SELECT ERP.ObtenerCantidadTotalDetallePedidoGuia(PD.IdProducto, @IdPedido)) 
	  END AS Cantidad
	  ,UM.Nombre NombreUnidadMedida
	  ,UM.CodigoSunat  CodigoSunatUnidadMedida
	  ,R.IdCliente
	  ,PD.PrecioUnitarioLista
	  ,PD.PrecioSubTotal
	  ,PD.PrecioIGV
	  ,PD.PrecioTotal
	  ,R.EstablecimientoDestino
  FROM ERP.PedidoDetalle PD
  LEFT JOIN ERP.Pedido R ON R.ID = PD.IdPedido
  LEFT JOIN ERP.Producto P ON P.ID = PD.IdProducto
  LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
  WHERE PD.IdPedido = @IdPedido AND (@IdGuiaRemision IS NULL OR (SELECT ERP.ObtenerCantidadTotalDetallePedidoGuia(PD.IdProducto, @IdPedido)) != 0)
END