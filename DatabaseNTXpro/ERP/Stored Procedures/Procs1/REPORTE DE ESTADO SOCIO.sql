﻿
CREATE PROC [ERP].[REPORTE DE ESTADO SOCIO]
@IdPedido INT
AS
BEGIN

DECLARE @IdComprobante INT = (SELECT TOP 1 OCR.IdComprobante 
								FROM ERP.ComprobanteReferencia OCR 
								INNER JOIN ERP.Comprobante C ON C.ID = OCR.IdComprobante
								WHERE OCR.IdReferencia = @IdPedido AND OCR.FlagInterno = 1 AND OCR.IdReferenciaOrigen = 9 AND C.FlagBorrador = 0 AND C.IdComprobanteEstado != 2)

SELECT PD.ID
      ,PD.IdPedido
      ,PD.IdProducto
	  	  ,E.Nombre
	  ,R.IdCliente
      ,PD.Nombre
      ,CASE WHEN @IdComprobante IS NULL THEN
		 PD.Cantidad
	  ELSE
	  (SELECT ERP.ObtenerCantidadTotalDetallePedidoComprobante(PD.IdProducto, @IdPedido)) 
	  END AS Cantidad
	  ,PD.PrecioUnitarioLista
	  ,PD.PrecioSubTotal
	  ,PD.PrecioIGV
	  ,PD.PrecioTotal
	  ,EstablecimientoDestino
  FROM ERP.PedidoDetalle PD
  LEFT JOIN ERP.Pedido R ON R.ID = PD.IdPedido
  LEFT JOIN ERP.Producto P ON P.ID = PD.IdProducto
  LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
  INNER JOIN ERP.Cliente C  ON C.ID=R.IdCliente
  INNER JOIN ERP.Entidad E  ON E.ID=C.IdEntidad
  WHERE PD.IdPedido = @IdPedido AND (@IdComprobante IS NULL OR (SELECT ERP.ObtenerCantidadTotalDetallePedidoComprobante(PD.IdProducto, @IdPedido)) != 1)
  END