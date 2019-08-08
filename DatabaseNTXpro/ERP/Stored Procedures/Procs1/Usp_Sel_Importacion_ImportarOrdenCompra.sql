CREATE PROCEDURE [ERP].[Usp_Sel_Importacion_ImportarOrdenCompra] --'15,46,47,48,49,57,58'
@Ids VARCHAR(MAX)
AS
BEGIN
	SELECT
		OC.ID AS IdOrdenCompra,
		OC.Documento AS DocumentoOrdenCompra,
		P.ID AS IdProducto,
		P.Nombre AS NombreProducto,
		OCD.Cantidad,
		OCD.PrecioUnitario,
		ISNULL(P.CodigoReferencia, '') AS CodigoReferencia
	FROM ERP.OrdenCompradetalle OCD
	INNER JOIN ERP.Producto P ON OCD.IdProducto = P.ID
	INNER JOIN ERP.OrdenCompra OC ON OC.ID = OCD.IdOrdenCompra
	WHERE OCD.ID IN (SELECT Data FROM [ERP].[Fn_SplitContenido](@Ids, ','))
	ORDER BY
	OC.ID,
	OCD.ID
END
