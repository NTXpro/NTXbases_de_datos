CREATE PROC [ERP].[Usp_Upd_Propiedad_Activar]
@IdPropiedad	INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	UPDATE [Maestro].[Propiedad] SET Flag = 1,FechaActivacion =DATEADD(HOUR, 3, GETDATE()) , UsuarioActivo = @UsuarioActivo  WHERE ID = @IdPropiedad
END
