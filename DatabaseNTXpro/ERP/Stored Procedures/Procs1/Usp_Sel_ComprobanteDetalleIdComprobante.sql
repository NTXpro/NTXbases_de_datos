
create PROC [ERP].[Usp_Sel_ComprobanteDetalleIdComprobante]
@IdComprobante INT
AS
BEGIN

	SELECT 
		CD.ID,
		CD.IdProducto,
		CD.Nombre,
		CD.Fecha,
		CD.NumeroLote,
		P.CodigoReferencia,
		CD.Cantidad,
		CD.PorcentajeDescuento,
		CD.PorcentajeISC,
		CASE WHEN C.IdComprobanteEstado = 3 THEN
			CAST(0 AS DECIMAL(14,5))
		ELSE	
			CD.PrecioUnitarioLista
		END AS PrecioUnitarioLista,
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
		CASE WHEN C.IdComprobanteEstado = 3 THEN
			CAST(0 AS DECIMAL(14,5))
		ELSE	
			CD.PrecioLista
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
			CD.PrecioIGV
		END AS PrecioIGV,
		
		CASE WHEN C.IdComprobanteEstado = 3 THEN
			CAST(0 AS DECIMAL(14,5))
		ELSE	
			CD.PrecioTotal
		END AS PrecioTotal,
		UM.Nombre NombreUnidadMedida,
		UM.CodigoSunat CodigoSunatUnidadMedida,
		M.Nombre NombreMarca,
		P.IdTipoProducto
	FROM ERP.ComprobanteDetalle CD INNER JOIN ERP.Producto P
		ON P.ID = CD.IdProducto
	LEFT JOIN PLE.T6UnidadMedida UM
		ON UM.ID = P.IdUnidadMedida
	LEFT JOIN Maestro.Marca M
		ON M.ID = P.IdMarca
	INNER JOIN ERP.Comprobante C
		ON C.ID = CD.IdComprobante
	WHERE IdComprobante = @IdComprobante

END