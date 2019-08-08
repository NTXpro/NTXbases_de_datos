

CREATE PROC [ERP].[Usp_Sel_PedidoDetalle_By_IdPedido]
@IdPedido INT
AS
BEGIN

	SELECT 
		CD.ID,
		CD.IdProducto,
		CD.Nombre,
		P.CodigoReferencia,
		CD.Cantidad,
		CD.PorcentajeDescuento,
		CD.PorcentajeISC,
		CD.PrecioUnitarioLista,
		CD.PrecioUnitarioValorISC,
		CD.PrecioUnitarioISC,
		CD.PrecioUnitarioDescuento,
		CD.PrecioUnitarioSubTotal,
		CD.PrecioUnitarioIGV,
		CD.PrecioUnitarioTotal,
		CD.PrecioPromedio,
		CD.FlagISC,
		CD.FlagAfecto,
		CD.FlagGratuito,
		CD.PrecioLista,
		CD.PrecioDescuento,
		CD.PrecioSubTotal,
		CD.PrecioIGV,
		CD.PrecioTotal,
		UM.Nombre NombreUnidadMedida,
		UM.CodigoSunat CodigoSunatUnidadMedida,
		M.Nombre NombreMarca,
		P.IdTipoProducto
	FROM ERP.PedidoDetalle CD INNER JOIN ERP.Producto P
		ON P.ID = CD.IdProducto
	LEFT JOIN PLE.T6UnidadMedida UM
		ON UM.ID = P.IdUnidadMedida
	LEFT JOIN Maestro.Marca M
		ON M.ID = P.IdMarca
	WHERE IdPedido = @IdPedido

END
