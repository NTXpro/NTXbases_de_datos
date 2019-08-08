
CREATE PROC [ERP].[Usp_Sel_Report_CotizacionDetalle_By_ID] --2
@IdCotizacion INT
AS
BEGIN
	SELECT	CD.Cantidad,
			UM.Nombre UnidadMedidad,
			CD.Nombre NombreProducto,
			P.CodigoReferencia,
			CD.PorcentajeDescuento,
			CD.PrecioUnitarioLista PrecioLista,
			CD.PrecioDescuento,
			CD.PrecioSubTotal PrecioSubTotal,
			CD.PrecioTotal PrecioTotal,
			CAST(0 AS BIT) FlagDescuento,
			(SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](C.IdEmpresa, 'VPU2', C.Fecha)) AS FlagPrecio2Decimal
	FROM ERP.CotizacionDetalle CD
	INNER JOIN ERP.Cotizacion C
		ON C.ID = CD.IdCotizacion
	INNER JOIN ERP.Producto P
		ON P.ID = CD.IdProducto
	LEFT JOIN PLE.T6UnidadMedida UM
		ON UM.ID = P.IdUnidadMedida
	WHERE CD.IdCotizacion = @IdCotizacion
END
