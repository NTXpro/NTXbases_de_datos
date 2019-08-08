
CREATE PROC [ERP].[Usp_Upd_UnidadMedida_Activar]
@IdUnidadMedida		INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	UPDATE [PLE].[T6UnidadMedida] SET Flag = 1, UsuarioActivo = @UsuarioActivo, FechaActivacion = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdUnidadMedida
END
