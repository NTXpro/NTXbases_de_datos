CREATE PROC [ERP].[Usp_Upd_Propiedad]
@IdPropiedad INT,
@IdUnidadMedida INT,
@Nombre VARCHAR(50),
@FlagBorrador BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN
	
	UPDATE [Maestro].[Propiedad] SET Nombre = @Nombre , FlagBorrador = @FlagBorrador , IdUnidadMedida = @IdUnidadMedida , UsuarioModifico = @UsuarioModifico, FechaModificado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdPropiedad 

END
