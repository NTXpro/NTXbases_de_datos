CREATE PROC [ERP].[Usp_Upd_Usuario_Activar]
@IdUsuario INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN

	UPDATE Seguridad.Usuario SET Flag = 1,UsuarioActivo = @UsuarioActivo ,FechaActivacion = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdUsuario
	
END