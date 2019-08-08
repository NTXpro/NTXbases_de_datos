CREATE PROC [ERP].[Usp_Upd_ListaPrecio_Activar]
@ID INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	UPDATE ERP.ListaPrecio SET FLAG = 1, UsuarioActivo = @UsuarioActivo,FechaActivacion = DATEADD(HOUR, 3, GETDATE())  WHERE ID = @ID
END