
CREATE PROC [ERP].[Usp_Upd_UnidadMedida]
@IdUnidadMedida INT,
@Nombre VARCHAR(50),
@CodigoSunat VARCHAR(3),
@UsuarioModifico VARCHAR(250),
@FlagBorrador BIT
AS
BEGIN
	
	UPDATE [PLE].[T6UnidadMedida] SET Nombre = @Nombre , CodigoSunat =@CodigoSunat, UsuarioModifico = @UsuarioModifico, FechaModificado = DATEADD(HOUR, 3, GETDATE()) , FlagBorrador = @FlagBorrador WHERE ID = @IdUnidadMedida 

END
