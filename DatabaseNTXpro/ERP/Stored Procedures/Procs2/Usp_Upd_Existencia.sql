
CREATE PROC [ERP].[Usp_Upd_Existencia]
@IdExistencia INT,
@Nombre VARCHAR(50),
@CodigoSunat VARCHAR(3),
@UsuarioModifico VARCHAR(250),
@FlagBorrador BIT
AS
BEGIN
	
	UPDATE [PLE].[T5Existencia] SET Nombre = @Nombre , CodigoSunat =@CodigoSunat , FlagBorrador = @FlagBorrador, UsuarioModifico = @UsuarioModifico, FechaModificado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdExistencia AND FlagSunat = 0

END
