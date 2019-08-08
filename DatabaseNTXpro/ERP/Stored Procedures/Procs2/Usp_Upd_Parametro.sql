

CREATE PROC [ERP].[Usp_Upd_Parametro] 
@IdParametro		INT,
@Valor				VARCHAR(20),
@UsuarioModifico	VARCHAR(250)
AS
BEGIN
	
	UPDATE [ERP].[Parametro] SET Valor=@Valor, UsuarioModifico=@UsuarioModifico ,FechaModificado=DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdParametro 
END
