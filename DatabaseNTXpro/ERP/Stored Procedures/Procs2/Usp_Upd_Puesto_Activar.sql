CREATE PROC [ERP].[Usp_Upd_Puesto_Activar]
@IdPuesto		INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	UPDATE [MAESTRO].[PUESTO] SET Flag = 1, UsuarioActivo = @UsuarioActivo, FechaActivacion = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdPuesto
END