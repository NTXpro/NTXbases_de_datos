CREATE PROC [ERP].[Usp_Upd_Proyecto_Activar]
@IdProyecto			INT,
@UsuarioActivo		VARCHAR(250)
AS
BEGIN
	UPDATE [ERP].[Proyecto] SET Flag = 1, FechaActivacion = DATEADD(HOUR, 3, GETDATE()),UsuarioActivo=@UsuarioActivo WHERE ID = @IdProyecto
END
