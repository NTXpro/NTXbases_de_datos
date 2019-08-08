
CREATE PROC [ERP].[Usp_Sel_Report_ComprobanteDetalleTicket_By_ID]
@IdComprobante INT
AS
BEGIN
WITH ListaComprobanteDetalleTicket AS (
	SELECT	CD.ID,
			CD.Cantidad,
			UM.CodigoSunat UnidadMedidad,
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
			0 AS ORDEN,
			(SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](C.IdEmpresa, 'VPU2', C.Fecha)) AS FlagPrecio2Decimal
	FROM ERP.ComprobanteDetalle CD
	INNER JOIN ERP.Comprobante C 
		ON C.ID = CD.IdComprobante
	INNER JOIN ERP.Producto P
		ON P.ID = CD.IdProducto
	LEFT JOIN PLE.T6UnidadMedida UM
		ON UM.ID = P.IdUnidadMedida
	WHERE CD.IdComprobante = @IdComprobante

	UNION

	SELECT	CD.ID,
			0 Cantidad,
			UM.CodigoSunat UnidadMedidad,
			'Descuento' NombreProducto,
			'' CodigoReferencia,
			CD.PorcentajeDescuento,
			- CD.PrecioDescuento PrecioLista,
			CD.PrecioDescuento,
			CD.PrecioSubTotal PrecioSubTotal,
			CD.PrecioTotal PrecioTotal,
			CAST(1 AS BIT) FlagDescuento,
			1 AS ORDEN,
			(SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](C.IdEmpresa, 'VPU2', C.Fecha)) AS FlagPrecio2Decimal
	FROM ERP.ComprobanteDetalle CD
	INNER JOIN ERP.Comprobante C 
		ON C.ID = CD.IdComprobante
	INNER JOIN ERP.Producto P
		ON P.ID = CD.IdProducto
	LEFT JOIN PLE.T6UnidadMedida UM
		ON UM.ID = P.IdUnidadMedida
	WHERE CD.IdComprobante = @IdComprobante AND CD.PrecioDescuento != 0 AND C.IdComprobanteEstado != 3)

	SELECT * FROM ListaComprobanteDetalleTicket ORDER BY ID,ORDEN



END
