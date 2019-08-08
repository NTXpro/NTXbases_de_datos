CREATE PROC [ERP].[Usp_Upd_Cuenta]
@IdCuenta INT,
@Nombre VARCHAR(50),
@CuentaInterbancaria VARCHAR(20),
@IdMoneda INT,
@IdEntidad INT,
@IdTipoCuenta INT,
@IdPlanCuenta INT,
@FechaApertura DATETIME,
@SaldoInicialDebe DECIMAL(16,5),
@SaldoInicialHaber DECIMAL(16,5),
@UsuarioModifico VARCHAR(250),
@FlagDetraccion BIT,
@FlagContabilidad BIT,
@FlagBorrador BIT,
@MostrarEnFE BIT
AS
BEGIN
		UPDATE ERP.Cuenta 
		SET	Nombre = @Nombre,
			CuentaInterbancario = @CuentaInterbancaria,
			IdMoneda = @IdMoneda,
			IdTipoCuenta = @IdTipoCuenta,
			IdPlanCuenta = @IdPlanCuenta,
			Fecha = @FechaApertura,
			SaldoInicialDebe = @SaldoInicialDebe,
			SaldoInicialHaber = @SaldoInicialHaber,
			UsuarioModifico = @UsuarioModifico,
			FechaModificado = DATEADD(HOUR, 3, GETDATE()),
			FlagDetraccion = @FlagDetraccion,
			FlagContabilidad = @FlagContabilidad,
			IdEntidad = @IdEntidad,
			FlagBorrador = @FlagBorrador,
			MostrarEnFE = @MostrarEnFE
		WHERE ID = @IdCuenta
END