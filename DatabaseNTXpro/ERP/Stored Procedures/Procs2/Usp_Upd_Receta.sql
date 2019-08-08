-- ==========================================================================================
-- Entity Name:     ERP.Usp_Upd_Receta
-- Author:    Omar Rodriguez
-- Create date:    28/7/2017 2:50:47 p. m.
-- Description:    Actualiza maestro de receta en el Sistema
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Upd_Receta]
(@ID                    [INT], 
 @IdEmpresa             INT, 
 @Nombre                [VARCHAR](250), 
 @ProductoTerminado     [VARCHAR](250), 
 @CantidadProdTerminado [INT], 
 @FechaModificado       [DATETIME], 
 @UsuarioModifico       [VARCHAR](250), 
 @FlagBorrador          [BIT], 
 @Flag                  [BIT],
 @IdAlmacen                INT,
 @IdProducto            INT,
 --------------------------------
  @XMLListarRecetaProductoDetalle XML
)
AS
     SET NOCOUNT ON;
     SET XACT_ABORT ON;
     BEGIN TRANSACTION;
     DECLARE @EXISTE INT = (SELECT COUNT(*) FROM [ERP].[Receta] WHERE LTRIM(RTRIM(Nombre)) = LTRIM(RTRIM(@Nombre))  AND ID != @ID AND IdEmpresa = @IdEmpresa)
     IF(@EXISTE = 0)
    BEGIN
    SET QUERY_GOVERNOR_COST_LIMIT 36000

    -- ELIMINAR DETALLE RECETA
    DELETE FROM ERP.RecetaProductoDetalle WHERE ERP.RecetaProductoDetalle.IdReceta= @ID
    -- FIN ELIMINAR
    -- INSERTAR PRODUCTO DETALLE

             INSERT INTO RecetaProductoDetalle
             (IdReceta, 
              IdProducto, 
              Cantidad
             )
                    SELECT @ID, 
                           (CASE T.N.value('IdProducto[1]', 'INT')
                                WHEN 0
                                THEN NULL
                                ELSE T.N.value('IdProducto[1]', 'INT')
                            END), 
                           T.N.value('Cantidad[1]', 'DECIMAL(18,5)')
                    FROM @XMLListarRecetaProductoDetalle.nodes('/RecetaProductoDetalle') AS T(N);

     -- FIN INSERTAR PRODUCTO DETALLE
     UPDATE ERP.Receta
       SET 
           Nombre = @Nombre, 
           ProductoTerminado = @ProductoTerminado, 
           CantidadProdTerminado = @CantidadProdTerminado, 
           UsuarioModifico = @UsuarioModifico, 
           FechaModificado = @FechaModificado, 
           FlagBorrador = @FlagBorrador, 
           Flag = @Flag,
           IdAlmacen = @IdAlmacen,
           IdProducto = @IdProducto    
     WHERE(ID = @ID);
         SELECT @ID;
     END
     ELSE
     BEGIN
        SELECT -1;
     END


     COMMIT;