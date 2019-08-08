-- ==========================================================================================
-- Entity Name:     ERP.Usp_Ins_Receta
-- Author:    Omar Rodriguez
-- Create date:    28/7/2017 2:50:47 p. m.
-- Description:    Insertar maestro de receta en el Sistema, retorna el IDgenerado
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Ins_Receta]
(@IdEmpresa                      INT, 
 @Nombre                         [VARCHAR](250), 
 @ProductoTerminado              [VARCHAR](250), 
 @CantidadProdTerminado          [INT], 
 @FechaRegistro                  [DATETIME], 
 @UsuarioRegistro                [VARCHAR](250), 
 @FlagBorrador                   [BIT], 
 @Flag                           [BIT],
 @IdAlmacen                         INT,
 @IdProducto                     INT,
 -------
 @XMLListarRecetaProductoDetalle XML
  
)
AS
     SET QUERY_GOVERNOR_COST_LIMIT 36000;
     SET XACT_ABORT ON;
     BEGIN TRANSACTION;
     DECLARE @EXISTE INT=
     (
         SELECT COUNT(*)
         FROM [ERP].[Receta]
         WHERE LTRIM(RTRIM(Nombre)) = LTRIM(RTRIM(@Nombre))
               AND IdEmpresa = @IdEmpresa
     );
     DECLARE @ID_RECETA INT;
     IF(@EXISTE = 0)
         BEGIN
             INSERT INTO ERP.Receta
             (Nombre, 
              idEmpresa, 
              ProductoTerminado, 
              CantidadProdTerminado, 
              FechaRegistro, 
              UsuarioRegistro, 
              FlagBorrador, 
              Flag,
              IdAlmacen,
              IdProducto
             )
             VALUES
             (@Nombre, 
              @IdEmpresa, 
              @ProductoTerminado, 
              @CantidadProdTerminado, 
              @FechaRegistro, 
              @UsuarioRegistro, 
              @FlagBorrador, 
              @Flag,
              @IdAlmacen,
              @IdProducto    
             );
             SET @ID_RECETA = CAST(SCOPE_IDENTITY() AS INT);

             ------ INSERTAR PRODUCTO DETALLE

             INSERT INTO RecetaProductoDetalle
             (IdReceta, 
              IdProducto, 
              Cantidad
             )
                    SELECT @ID_RECETA, 
                           (CASE T.N.value('IdProducto[1]', 'INT')
                                WHEN 0
                                THEN NULL
                                ELSE T.N.value('IdProducto[1]', 'INT')
                            END), 
                           T.N.value('Cantidad[1]', 'DECIMAL(18,5)')
                    FROM @XMLListarRecetaProductoDetalle.nodes('/RecetaProductoDetalle') AS T(N);

             ------ FIN INSERTAR PRODUCTO DETALLE

             SELECT @ID_RECETA;
         END;
         ELSE
         BEGIN
             SELECT-1;
         END;
     COMMIT;