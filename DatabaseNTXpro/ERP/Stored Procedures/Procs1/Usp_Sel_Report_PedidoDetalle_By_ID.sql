
CREATE PROC [ERP].[Usp_Sel_Report_PedidoDetalle_By_ID]
@IdPedido INT
AS
BEGIN
	SELECT	CD.Cantidad,
			UM.Nombre UnidadMedidad,
			CD.Nombre NombreProducto,
			P.CodigoReferencia,
			CD.PorcentajeDescuento,
			CD.PrecioUnitarioLista PrecioLista,
			CD.PrecioDescuento,
			CD.PrecioTotal PrecioTotal,
			CAST(0 AS BIT) FlagDescuento,
			(SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](C.IdEmpresa, 'VPU2', C.Fecha)) AS FlagPrecio2Decimal
	FROM ERP.PedidoDetalle CD
	INNER JOIN ERP.Pedido C
		ON C.ID = CD.IdPedido
	INNER JOIN ERP.Producto P
		ON P.ID = CD.IdProducto
	LEFT JOIN PLE.T6UnidadMedida UM
		ON UM.ID = P.IdUnidadMedida
	WHERE CD.IdPedido = @IdPedido
END
