
CREATE PROC [ERP].[Usp_Upd_Proveedor_Activar]
@IdProveedor			INT,
@UsuarioActivo			VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Proveedor SET Flag = 1 ,FechaActivacion = DATEADD(HOUR, 3, GETDATE()),UsuarioActivo=@UsuarioActivo WHERE ID = @IdProveedor
END
