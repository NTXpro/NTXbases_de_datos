CREATE PROC ERP.Usp_Upd_TrabajadorCuenta
@ID INT
,@IdBanco INT
,@Fecha DATETIME
,@NumeroCuenta VARCHAR(50)
,@NumeroCuentaInterbancario VARCHAR(50)
,@UsuarioModifico VARCHAR(250)
AS
BEGIN
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
	UPDATE ERP.TrabajadorCuenta SET IdBanco = @IdBanco,
									Fecha = @Fecha,
									NumeroCuenta = @NumeroCuenta,
									NumeroCuentaInterbancario = @NumeroCuentaInterbancario,
									FechaModificado = @FechaActual,
									UsuarioModifico = @UsuarioModifico
	WHERE ID= @ID
							
	SELECT @ID				
END
