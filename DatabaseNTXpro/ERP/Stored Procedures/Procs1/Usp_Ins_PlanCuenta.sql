
CREATE PROC [ERP].[Usp_Ins_PlanCuenta]
@IdPlanCuenta	INT OUT,
@IdEmpresa		INT,
@IdGrado		INT,
@IdColumnaBase	INT,
@IdMoneda		INT,
@IdTipoCambio	INT,
@IdAnio			INT,
@CuentaContable VARCHAR(20),
@Nombre			VARCHAR(50),
@EstadoAnalisis BIT,
@EstadoProyecto BIT,
@FlagBorrador	BIT,
@UsuarioRegistro	VARCHAR(250)
AS
BEGIN
		INSERT INTO [ERP].[PlanCuenta] (IdEmpresa,IdAnio,CuentaContable,Nombre,IdGrado,IdColumnaBalance,IdMoneda,IdTipoCambio,EstadoAnalisis,EstadoProyecto,FlagBorrador,Flag,FechaRegistro,UsuarioRegistro,UsuarioModifico,FechaModificado)
									VALUES (@IdEmpresa,@IdAnio,@CuentaContable,@Nombre,@IdGrado,@IdColumnaBase,@IdMoneda,@IdTipoCambio,@EstadoAnalisis,@EstadoProyecto,@FlagBorrador,1,DATEADD(HOUR, 3, GETDATE()),@UsuarioRegistro,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()));
			SET @IdPlanCuenta = (SELECT CAST(SCOPE_IDENTITY() AS int));
END
