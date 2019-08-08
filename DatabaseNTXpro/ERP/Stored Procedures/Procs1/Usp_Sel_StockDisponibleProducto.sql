


-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 16/10/2018
-- Description:	PROCEDIMIENTO PARA LISTAR LOS COMPONENTES CON STOCK NEGATIVO EN EL RECETA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Sel_StockDisponibleProducto] 
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
WHERE cd.IdComprobante =@IdComprobante
) B
WHERE B.Resta < 0
END