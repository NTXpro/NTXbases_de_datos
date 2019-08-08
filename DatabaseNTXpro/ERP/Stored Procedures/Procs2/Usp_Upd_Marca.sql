CREATE PROC [ERP].[Usp_Upd_Marca]
@IdMarca INT,
@Nombre VARCHAR(50),
@UsuarioModifico VARCHAR(250),
@FlagBorrador BIT
AS
BEGIN
	
	UPDATE [Maestro].[Marca] SET Nombre = @Nombre , FlagBorrador = @FlagBorrador, UsuarioModifico = @UsuarioModifico, FechaModificado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdMarca 

END
