-- ==========================================================================================
-- Entity Name:     ERP.Usp_Upd_Receta_Activar
-- Author:    Omar Rodriguez
-- Create date:    12/7/2018 2:50:47 p. m.
-- Description:    Activar una receta del sistema
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Upd_Receta_Activar]
(@ID             [INT], 
 @UsuarioActivo [VARCHAR](250), 
 @FechaActivacion [DATETIME]
)
AS
     SET NOCOUNT ON;
     SET XACT_ABORT ON;
     BEGIN TRANSACTION;
     UPDATE ERP.Receta
       SET 
           UsuarioActivo = @UsuarioActivo, 
           FechaActivacion = @FechaActivacion, 
           Flag = 1
     WHERE(ID = @ID);
     COMMIT;