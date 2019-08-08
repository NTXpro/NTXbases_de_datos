
CREATE PROC [ERP].[Usp_Upd_PlanCuenta] 
@IdPlanCuenta INT,
@IdGrado INT,
@IdColumnaBase INT,
@IdMoneda INT,
@IdTipoCambio INT,
@Nombre  VARCHAR(50),
@CuentaContable VARCHAR(50),
@FlagBorrador BIT,
@EstadoAnalisis BIT,
@EstadoProyecto BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN
	
	UPDATE [ERP].[PlanCuenta] SET IdGrado=@IdGrado, 
								IdColumnaBalance = @IdColumnaBase , 
								IdMoneda = @IdMoneda , 
								IdTipoCambio=@IdTipoCambio,
								Nombre = @Nombre ,
								CuentaContable=@CuentaContable,
								FlagBorrador = @FlagBorrador,
								EstadoAnalisis = @EstadoAnalisis,
								EstadoProyecto=@EstadoProyecto,
								UsuarioModifico=@UsuarioModifico,
								FechaModificado=DATEADD(HOUR, 3, GETDATE())
								
	WHERE ID = @IdPlanCuenta 
END
