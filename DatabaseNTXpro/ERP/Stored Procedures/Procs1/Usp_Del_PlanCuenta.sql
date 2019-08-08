CREATE PROC [ERP].[Usp_Del_PlanCuenta]
@IdPlanCuenta	INT
AS
BEGIN
		DELETE FROM [ERP].[PlanCuenta] WHERE ID = @IdPlanCuenta
END
