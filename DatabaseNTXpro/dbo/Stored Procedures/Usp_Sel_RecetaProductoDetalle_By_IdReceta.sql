-- =============================================
-- Author:        Omar Rodriguez
-- Create date: 1907/2018
-- Description:    Lista el detalle de producto de la receta
-- =============================================
CREATE PROCEDURE [dbo].[Usp_Sel_RecetaProductoDetalle_By_IdReceta]
    @IdReceta INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON
    BEGIN TRANSACTION
    
SELECT rpd.ID, 
       rpd.IdReceta, 
       rpd.IdProducto, 
       rpd.Cantidad,
       p.Nombre,
       p.IdUnidadMedida,
       tm.Nombre AS NombreUnidadMedida
       
FROM ERP.RecetaProductoDetalle rpd
     INNER JOIN ERP.Producto p ON rpd.IdProducto = p.ID
     LEFT JOIN PLE.T6UnidadMedida tm ON  p.IdUnidadMedida = tm.ID
     WHERE rpd.IdReceta=@IdReceta
    COMMIT
END