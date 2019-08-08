CREATE PROC [ERP].[Usp_Upd_Talonario]
@IdTalonario INT,
@IdCuenta INT,
@Inicio INT,
@Fin INT,
@FlagBorrador BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN
	
	UPDATE ERP.Talonario SET IdCuenta = @IdCuenta,
							 Inicio = @Inicio,
						     Fin = @Fin,
							 UsuarioModifico = @UsuarioModifico,
							 FlagBorrador = @FlagBorrador,
							 FechaModificado = DATEADD(HOUR,3,GETDATE())
	WHERE ID = @IdTalonario

END
