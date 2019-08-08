CREATE PROC [ERP].[Usp_Upd_PlanCuenta_Desactivar]
@IdPlanCuenta	INT,
@UsuarioElimino	VARCHAR(250)
AS
BEGIN
	UPDATE [ERP].[PlanCuenta] SET Flag = 0, FechaEliminado = DATEADD(HOUR, 3, GETDATE()) ,UsuarioElimino=@UsuarioElimino WHERE ID = @IdPlanCuenta
END
