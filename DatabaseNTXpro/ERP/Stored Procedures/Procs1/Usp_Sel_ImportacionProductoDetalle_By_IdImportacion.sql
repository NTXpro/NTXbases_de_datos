CREATE PROCEDURE [ERP].[Usp_Sel_ImportacionProductoDetalle_By_IdImportacion] --121
@IdImportacion INT
AS
BEGIN
	SELECT
		IPD.ID,
		IPD.IdOrdenCompra,
		OC.Documento AS DocumentoOrdenCompra,
		IPD.IdImportacion,
		IPD.IdProducto,
		IPD.Fecha,
		CONVERT(VARCHAR(10), IPD.Fecha, 103) AS FechaStr,
		ISNULL(IPD.Lote, VD.NumeroLote) AS Lote,
		--IPD.Lote,
		IPD.Cantidad,
		IPD.PrecioUnitario,
		IPD.Total,
		IPD.PrecioUnitarioCosteo,
		IPD.TotalCosteo,
		UPPER(P.CodigoReferencia) AS CodigoReferencia,
		P.Nombre AS NombreProducto,
		UM.Nombre AS NombreUnidadMedida
	FROM [ERP].[ImportacionProductoDetalle] IPD
	LEFT JOIN ERP.Producto P ON IPD.IdProducto = P.ID
	LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
	LEFT JOIN ERP.OrdenCompra OC ON IPD.IdOrdenCompra = OC.ID
	---------------------------------------------------------------
	LEFT JOIN ERP.Importacion I ON IPD.IdImportacion = I.ID
	LEFT JOIN ERP.Vale V ON I.IdVale = V.ID
	LEFT JOIN ERP.ValeDetalle VD ON V.ID = VD.IdVale AND IPD.Item = VD.Item
	WHERE IPD.IdImportacion = @IdImportacion
END
