-- ==========================================================================================
-- Entity Name:     ERP.Usp_Del_Receta
-- Author:    Omar Rodriguez
-- Create date:    28/7/2017 2:50:47 p. m.
-- Description:    Elimina maestro de receta en el Sistema por @ID
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Del_Receta]
        @ID [int]
AS
    SET NOCOUNT ON
    SET XACT_ABORT ON
    
    BEGIN TRANSACTION
        DELETE ERP.RecetaProductoDetalle WHERE ERP.RecetaProductoDetalle.IdReceta =@ID
        DELETE FROM ERP.Receta
        WHERE (ID = @ID)
    COMMIT