CREATE PROC [ERP].[Usp_Upd_Puesto]
@IdPuesto INT ,
@IdOcupacion INT,
@Nombre VARCHAR(50),

@UsuarioModifico VARCHAR(250),
@FlagBorrador BIT
AS
BEGIN
	DECLARE @ValorParametro int= isnull((SELECT TOP 1 cast(PA.Valor AS int) FROM ERP.Parametro PA 
											
											WHERE PA.Abreviatura = 'SHA'),0)
	
	UPDATE [MAESTRO].[PUESTO] SET  IdOcupacion=@IdOcupacion,Nombre = @Nombre , UsuarioModifico = @UsuarioModifico, FechaModificado = DATEADD(HOUR, @ValorParametro, GETDATE()) ,FlagBorrador = @FlagBorrador WHERE ID = @IdPuesto
	
END