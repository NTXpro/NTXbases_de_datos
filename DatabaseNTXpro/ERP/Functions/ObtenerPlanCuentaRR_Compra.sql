CREATE FUNCTION [ERP].[ObtenerPlanCuentaRR_Compra](@IdEmpresa INT, @IdPeriodo INT)
RETURNS INT
AS
BEGIN

DECLARE @IdPlanCuenta INT = (SELECT TOP 1 ID FROM ERP.PlanCuenta PC 
WHERE PC.CuentaContable = (SELECT TOP 1 Valor FROM ERP.Parametro P WHERE Abreviatura = 'PCRRC' AND P.IdEmpresa = @IdEmpresa)AND PC.IdEmpresa = @IdEmpresa
AND IdAnio = (SELECT IdAnio FROM ERP.Periodo WHERE ID = @IdPeriodo))

RETURN @IdPlanCuenta

END
