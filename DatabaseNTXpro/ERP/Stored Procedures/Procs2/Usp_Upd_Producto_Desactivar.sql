
CREATE PROC [ERP].[Usp_Upd_Producto_Desactivar]
@IdProducto		INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Producto SET Flag = 0, FechaEliminado = DATEADD(HOUR, 3, GETDATE()) ,UsuarioElimino=@UsuarioElimino  WHERE ID = @IdProducto AND IdTipoProducto= 1
	DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Producto WHERE ID = @IdProducto)
	DELETE FROM ERP.FamiliaProducto WHERE IdProducto = @IdProducto
END
