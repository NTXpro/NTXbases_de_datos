CREATE PROC [ERP].[Usp_Upd_Banco_Desactivar]
@IdBanco			INT,
@UsuarioElimino		VARCHAR(250)
AS
BEGIN
	UPDATE [PLE].[T3Banco] SET Flag = 0 , FechaEliminado = DATEADD(HOUR, 3, GETDATE()),UsuarioElimino=@UsuarioElimino WHERE ID = @IdBanco
END
