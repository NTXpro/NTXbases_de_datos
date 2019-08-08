CREATE PROC [ERP].[Usp_Upd_Marca_Activar]
@IdMarca		INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	UPDATE Maestro.Marca SET Flag = 1, UsuarioActivo = @UsuarioActivo, FechaActivacion = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdMarca
END
