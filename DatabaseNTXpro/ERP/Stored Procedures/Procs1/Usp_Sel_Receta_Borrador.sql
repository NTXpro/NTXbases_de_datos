-- ==========================================================================================
-- Entity Name:     ERP.Usp_Upd_Receta_borrador
-- Author:    Omar Rodriguez
-- Create date:    12/7/2018 2:50:47 p. m.
-- Description:    Lista receta en borradores del sistema
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Sel_Receta_Borrador]
@IdEmpresa INT
AS
     SET NOCOUNT ON;
     SET XACT_ABORT ON;
     BEGIN TRANSACTION;
     SELECT r.ID, 
            r.Nombre, 
            r.ProductoTerminado, 
            r.FechaRegistro
     FROM ERP.Receta r
     WHERE r.Flag = 1
           AND r.FlagBorrador = 1 AND r.idEmpresa=@IdEmpresa;
     COMMIT;