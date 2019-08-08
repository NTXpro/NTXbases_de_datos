-- ==========================================================================================
-- Entity Name:     ERP.Usp_Sel_Receta_By_Empresa
-- Author:    Omar Rodriguez
-- Create date:    31/8/2018 2:50:47 p. m.
-- Description:    Listar el maestro de recetas por Empresa
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Sel_Receta_By_Empresa] @IdEmpresa INT
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
     WHERE(ERP.Receta.idEmpresa=@IdEmpresa) AND ERP.Receta.FlagBorrador=0 AND ERP.Receta.Flag= 1;
     COMMIT;