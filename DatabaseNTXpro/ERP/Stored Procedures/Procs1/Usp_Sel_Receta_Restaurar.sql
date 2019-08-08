-- ==========================================================================================
-- Entity Name:     ERP.Usp_Sel_Receta_Restaurar
-- Author:    Omar Rodriguez
-- Create date:    13/7/2018 2:50:47 p. m.
-- Description:    Lista recetas inactivas
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Sel_Receta_Restaurar]
 @IdEmpresa INT
AS
     SET NOCOUNT ON;
     SET XACT_ABORT ON;
     BEGIN TRANSACTION;
     SELECT r.ID, 
            r.Nombre, 
            r.ProductoTerminado, 
            r.CantidadProdTerminado
     FROM ERP.Receta r
     WHERE r.idEmpresa = @IdEmpresa
           AND r.Flag = 0;
     COMMIT;