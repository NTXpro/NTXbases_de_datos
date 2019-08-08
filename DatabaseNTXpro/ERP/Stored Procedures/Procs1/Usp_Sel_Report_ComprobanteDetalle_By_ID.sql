CREATE PROC [ERP].[Usp_Sel_Report_ComprobanteDetalle_By_ID]
@IdComprobante INT
AS
BEGIN
	SELECT	CD.Cantidad,
			UM.CodigoSunat UnidadMedida,
			UM.Nombre NombreUnidadMedida,
			CD.Nombre NombreProducto,
			P.CodigoReferencia,
			CASE WHEN C.IdComprobanteEstado = 3 THEN
				CAST(0 AS DECIMAL(14,5))
			ELSE
				CD.PorcentajeDescuento
			END AS PorcentajeDescuento,
			CASE WHEN C.IdComprobanteEstado = 3 THEN
				CAST(0 AS DECIMAL(14,5))
			ELSE
				CD.PrecioUnitarioLista
			END AS PrecioLista,
			CASE WHEN C.IdComprobanteEstado = 3 THEN
				CAST(0 AS DECIMAL(14,5))
			ELSE
				CD.PrecioDescuento
			END AS PrecioDescuento,
			CASE WHEN C.IdComprobanteEstado = 3 THEN
				CAST(0 AS DECIMAL(14,5))
			ELSE
				CD.PrecioSubTotal 
			END AS PrecioSubTotal,
			CASE WHEN C.IdComprobanteEstado = 3 THEN
				CAST(0 AS DECIMAL(14,5))
			ELSE
			CD.PrecioTotal 
			END AS PrecioTotal,
			CAST(0 AS BIT) FlagDescuento,
			(SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](C.IdEmpresa, 'VPU2', C.Fecha)) AS FlagPrecio2Decimal
	FROM ERP.ComprobanteDetalle CD
	INNER JOIN ERP.Comprobante C
		ON C.ID = CD.IdComprobante
	INNER JOIN ERP.Producto P
		ON P.ID = CD.IdProducto
	LEFT JOIN PLE.T6UnidadMedida UM
		ON UM.ID = P.IdUnidadMedida
	WHERE CD.IdComprobante = @IdComprobante
END