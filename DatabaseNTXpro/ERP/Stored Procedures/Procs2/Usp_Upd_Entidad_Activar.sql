
CREATE PROC [ERP].[Usp_Upd_Entidad_Activar]
@IdEntidad			INT,
@UsuarioActivo	VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Entidad SET Flag = 1 ,UsuarioActivo=@UsuarioActivo, FechaActivacion = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdEntidad 
END
