CREATE PROC [ERP].[Usp_Upd_Banco_Activar]
@IdBanco		INT,
@UsuarioActivo	VARCHAR(250)
AS
BEGIN
	UPDATE [PLE].[T3Banco] SET Flag = 1 ,FechaActivacion = DATEADD(HOUR, 3, GETDATE()),UsuarioActivo=@UsuarioActivo WHERE ID = @IdBanco
END