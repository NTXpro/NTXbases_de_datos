CREATE PROC [ERP].[Usp_Ins_Cuenta]
@IdCuenta INT OUT,
@Nombre VARCHAR(50),
@CuentaInterbancaria VARCHAR(20),
@IdEmpresa INT,
@IdEntidad INT,
@IdMoneda INT,
@IdTipoCuenta INT,
@IdPlanCuenta INT,
@FechaApertura DATETIME,
@SaldoInicialDebe DECIMAL(14,5),
@SaldoInicialHaber DECIMAL(14,5),
@UsuarioRegistro VARCHAR(250),
@FlagDetraccion BIT,
@FlagContabilidad BIT,
@FlagBorrador BIT,
@MostrarEnFE BIT
AS
BEGIN
	INSERT INTO ERP.Cuenta(Nombre, CuentaInterbancario, IdEmpresa,IdEntidad,IdMoneda,IdTipoCuenta,IdPlanCuenta,Fecha,SaldoInicialDebe,SaldoInicialHaber,UsuarioRegistro,FechaRegistro,UsuarioModifico,FechaModificado, FlagDetraccion,FlagContabilidad,FlagBorrador,Flag, MostrarEnFE)
	VALUES (@Nombre,@CuentaInterbancaria, @IdEmpresa,@IdEntidad,@IdMoneda,@IdTipoCuenta,@IdPlanCuenta,@FechaApertura,@SaldoInicialDebe,@SaldoInicialHaber,@UsuarioRegistro,GETDATE(),@UsuarioRegistro,GETDATE(),@FlagDetraccion,@FlagContabilidad,@FlagBorrador,1, @MostrarEnFE)

	SET @IdCuenta = (SELECT CAST(SCOPE_IDENTITY() AS INT));
END