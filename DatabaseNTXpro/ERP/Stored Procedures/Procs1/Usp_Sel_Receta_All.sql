-- ==========================================================================================
-- Entity Name:     ERP.Usp_Sel_Receta_All
-- Author:    Omar Rodriguez
-- Create date:    28/7/2017 2:50:47 p. m.
-- Description:    Listar el maestro de recetas por Idempresa 
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Sel_Receta_All] @idEmpresa [INT]
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
     WHERE(idEmpresa = @idEmpresa
           OR @idEmpresa IS NULL)
          AND FlagBorrador = 0
          AND Flag = 1;
     COMMIT;