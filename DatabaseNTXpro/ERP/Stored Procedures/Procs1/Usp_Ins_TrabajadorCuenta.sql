CREATE PROC ERP.Usp_Ins_TrabajadorCuenta
@ID INT OUT
,@IdEmpresa INT
,@IdTrabajador INT
,@IdBanco INT
,@IdTipoCuenta INT
,@Fecha DATETIME
,@NumeroCuenta VARCHAR(50)
,@NumeroCuentaInterbancario VARCHAR(50)
,@UsuarioRegistro VARCHAR(250)
AS
BEGIN
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());

	INSERT INTO ERP.TrabajadorCuenta(
								   IdEmpresa
								  ,IdTrabajador
								  ,IdBanco
								  ,IdTipoCuenta
								  ,Fecha
								  ,NumeroCuenta
								  ,NumeroCuentaInterbancario
								  ,FechaRegistro
								  ,UsuarioRegistro
								)VALUES(
								   @IdEmpresa
								  ,@IdTrabajador
								  ,@IdBanco
								  ,@IdTipoCuenta
								  ,@Fecha
								  ,@NumeroCuenta
								  ,@NumeroCuentaInterbancario
								  ,@FechaActual
								  ,@UsuarioRegistro
								)
	SET @ID = CAST(SCOPE_IDENTITY() AS int)
	SELECT @ID
END
