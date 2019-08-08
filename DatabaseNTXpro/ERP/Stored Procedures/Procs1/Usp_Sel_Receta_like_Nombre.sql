-- ==========================================================================================
-- Entity Name:     ERP.Usp_Sel_Receta_By_Nombre
-- Author:    Omar Rodriguez
-- Create date:    13/8/2018 2:50:47 p. m.
-- Description:    Listar el maestro de recetas por nombre
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Sel_Receta_like_Nombre] @NOMBRE VARCHAR(250)
AS
     SET NOCOUNT ON;
     SET XACT_ABORT ON;
     BEGIN TRANSACTION;
     SELECT ID, 
            idEmpresa, 
            Nombre, 
            ProductoTerminado, 
            CantidadProdTerminado, 
            Fecha, 
            FechaIngreso, 
            FechaSalida, 
            UsuarioRegistro, 
            FechaRegistro, 
            UsuarioModifico, 
            FechaModificado, 
            UsuarioActivo, 
            FechaActivacion, 
            UsuarioElimino, 
            FechaEliminado, 
            FlagBorrador, 
            Flag,
            IdAlmacen,
            IdProducto    

     FROM ERP.Receta
     WHERE(ERP.Receta.Nombre LIKE '%'+@NOMBRE+'%' );
     COMMIT;