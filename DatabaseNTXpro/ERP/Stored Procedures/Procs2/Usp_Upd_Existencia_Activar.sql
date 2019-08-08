CREATE PROC [ERP].[Usp_Upd_Existencia_Activar]
@IdExistencia		INT,
@UsuarioActivo		VARCHAR(250)
AS
BEGIN
	UPDATE [PLE].[T5Existencia] SET Flag = 1 , UsuarioActivo = @UsuarioActivo, FechaActivacion = DATEADD(HOUR, 3, GETDATE())  WHERE ID = @IdExistencia
END
