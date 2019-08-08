-- =============================================
-- Author:        Omar Rodriguez
-- Create date: 08/08/2018
-- Description:    Lista el nombre de las recetas que tienen el producto asociado
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Sel_Producto_En_Recetas]
    @IdProducto INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON
    BEGIN TRANSACTION
    
SELECT DISTINCT r.Nombre
FROM ERP.RecetaProductoDetalle rpd INNER JOIN ERP.Receta r ON rpd.IdReceta = r.ID
  WHERE rpd.IdProducto = @IdProducto ORDER BY r.Nombre  
    COMMIT
END