-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 15/10/2018
-- Description:	LISTADO DE ITEMS DE RECETA CON CANTIDADES MENORES AL 
--				COMPROBANTE
-- =============================================
CREATE PROCEDURE ERP.Usp_List_ExistenciaItemsReceta
	@IdComprobante int
AS
BEGIN
	SELECT B.Producto, B.Receta, B.StockDisponible, B.Resta FROM (
SELECT 
 p.Nombre AS Producto,r.Nombre AS Receta
 ,ERP.StockDisponibleProducto(c.IdEmpresa, rpd.IdProducto,c.IdAlmacen) as StockDisponible
, (ERP.StockDisponibleProducto(c.IdEmpresa, rpd.IdProducto,c.IdAlmacen)- (cd.Cantidad * rpd.Cantidad)) AS Resta
FROM ERP.ComprobanteDetalle cd 
LEFT JOIN ERP.Comprobante c ON cd.IdComprobante = c.ID
RIGHT JOIN ERP.Receta r ON cd.IdProducto = r.IdProducto
RIGHT JOIN ERP.RecetaProductoDetalle rpd ON r.ID = rpd.IdReceta
RIGHT JOIN ERP.Producto p ON rpd.IdProducto = p.ID
WHERE cd.IdComprobante =@IdComprobante) B WHERE B.Resta < 0


END