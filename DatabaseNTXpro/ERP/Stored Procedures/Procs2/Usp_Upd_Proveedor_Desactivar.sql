
CREATE PROC [ERP].[Usp_Upd_Proveedor_Desactivar]
@IdProveedor			INT,
@UsuarioElimino			VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Proveedor SET Flag = 0 ,FechaEliminado =DATEADD(HOUR, 3, GETDATE()),UsuarioElimino=@UsuarioElimino WHERE ID = @IdProveedor
END
