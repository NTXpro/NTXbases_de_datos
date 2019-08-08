-- ==========================================================================================
-- Entity Name:     ERP.Usp_Upd_Receta_Desactivar
-- Author:    Omar Rodriguez
-- Create date:    12/7/2018 2:50:47 p. m.
-- Description:    Elimina una receta del sistema
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Upd_Receta_Desactivar]
(@ID             [INT], 
 @UsuarioElimino [VARCHAR](250), 
 @FechaEliminado [DATETIME]
)
AS
     SET NOCOUNT ON;
     SET XACT_ABORT ON;
     BEGIN TRANSACTION;
     UPDATE ERP.Receta
       SET 
           UsuarioElimino = @UsuarioElimino, 
           FechaEliminado = @FechaEliminado, 
           Flag = 0
     WHERE(ID = @ID);
     COMMIT;