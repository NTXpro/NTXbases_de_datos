-- ==========================================================================================
-- Entity Name:     ERP.Usp_Ins_Copiar_Receta
-- Author:    Omar Rodriguez
-- Create date:    13/8/2018 2:50:47 p. m.
-- Description:    Insertar un duplicado de la receta con un nuevo nombre
-- ==========================================================================================
CREATE PROCEDURE [ERP].[Usp_Ins_Copiar_Receta]
(@ID          INT, 
 @NOMBRENUEVO [VARCHAR](250),
 @IDPRODUCTONUEVO INT

)
AS
     SET QUERY_GOVERNOR_COST_LIMIT 36000;
     SET XACT_ABORT ON;
     BEGIN TRANSACTION;
     DECLARE @IDNUEVARECETA INT =-1;
     ---- MAESTRO  ------------------------------
     INSERT INTO ERP.Receta
     (idEmpresa, 
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
     )
            SELECT r.idEmpresa, 
                   @NOMBRENUEVO, 
                   r.ProductoTerminado, 
                   r.CantidadProdTerminado, 
                   r.Fecha, 
                   r.FechaIngreso, 
                   r.FechaSalida, 
                   r.UsuarioRegistro, 
                   r.FechaRegistro, 
                   r.UsuarioModifico, 
                   r.FechaModificado, 
                   r.UsuarioActivo, 
                   r.FechaActivacion, 
                   r.UsuarioElimino, 
                   r.FechaEliminado, 
                   r.FlagBorrador, 
                   r.Flag,
                   r.IdAlmacen,
                   @IDPRODUCTONUEVO
            FROM ERP.Receta r
            WHERE R.ID = @ID;

     ---- DETALLE  ------------------------------
      SET @IDNUEVARECETA = CAST(SCOPE_IDENTITY() AS INT);
     INSERT INTO ERP.RecetaProductoDetalle
     (IdReceta, 
      IdProducto, 
      Cantidad
     )
            SELECT @IDNUEVARECETA, 
                   rpd.IdProducto, 
                   rpd.Cantidad
            FROM ERP.RecetaProductoDetalle rpd
            WHERE rpd.IdReceta = @ID;
    
    SELECT @IDNUEVARECETA
            
     COMMIT;