CREATE PROC [ERP].Usp_Sel_ComprobanteDetalle_By_ListaComprobante
@IdComprobantes VARCHAR(250)
AS
BEGIN


	SELECT CD.IdProducto,
		   CD.Nombre,
		   PRO.CodigoReferencia,
		   CD.PrecioUnitarioLista,
		   CD.FlagAfecto,
		   T6.CodigoSunat UnidadMedida,
		   CD.Cantidad,
		   CD.PrecioIGV,
		   CD.PrecioTotal
	FROM ERP.ComprobanteDetalle CD
	INNER JOIN ERP.Producto PRO ON PRO.ID = CD.IdProducto
	INNER JOIN PLE.T6UnidadMedida T6 ON T6.ID = PRO.IdUnidadMedida
	WHERE CD.IdComprobante IN (SELECT DATA FROM ERP.Fn_SplitContenido(@IdComprobantes,',')) AND PRO.IdTipoProducto = 1
END
