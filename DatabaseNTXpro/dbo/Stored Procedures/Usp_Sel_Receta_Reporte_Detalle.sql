-- =============================================
-- Author:        OMAR RODRIGUEZ
-- Create date: 17-08-2018
-- Description:    LISTADO PARA REPORTE DETALLADO DE RECETAS
--                PARAMETRO @IdEmpresa= NULL IMPRIME TODOS LOS REGISTROS

-- =============================================
CREATE PROCEDURE [dbo].[Usp_Sel_Receta_Reporte_Detalle]
    @ID INT
AS
BEGIN
SELECT --r.id,
       r.idEmpresa, 
       r.Nombre, 
      
       r.CantidadProdTerminado, 
       r.Fecha, 
       r.FechaIngreso, 
       r.FechaSalida, 
       r.UsuarioRegistro, 
       r.FechaRegistro, 
       r.UsuarioModifico, 
       r.FechaModificado, 
       r.UsuarioActivo, 
       r.FechaActivacion, 
       r.UsuarioElimino, 
       r.FechaEliminado, 
       r.FlagBorrador, 
       r.Flag, 
       r.idAlmacen, 
       r.IdProducto, 
       p.Nombre AS NombreProductoTerminado, 
       rpd.ID AS IdDetalle, 
       rpd.IdProducto AS IdProductoDetalle, 
       p2.Nombre AS NombreProductoDetalle, 
       t6.Nombre AS UnidadMedida, 
       rpd.Cantidad,
        r.ProductoTerminado,
        a.Nombre AS NombreAlmacen
         
FROM ERP.Receta r
     INNER JOIN erp.RecetaProductoDetalle rpd ON r.ID = rpd.IdReceta
     LEFT JOIN erp.Producto p ON r.IdProducto = p.ID
     LEFT JOIN erp.Producto p2 ON rpd.IdProducto = p2.ID
     LEFT JOIN erp.Almacen a ON r.idAlmacen = a.ID
     LEFT JOIN ple.T6UnidadMedida t6 ON p2.IdUnidadMedida = t6.ID
      where (r.id = @ID or @ID is null)

END