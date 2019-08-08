
CREATE FUNCTION [ERP].[ObtenerPlanCuentaAsiento40](
@IdEmpresa INT,
@Fecha DATETIME
)
RETURNS INT
AS
BEGIN
DECLARE @IdPlanCuenta INT = (SELECT TOP 1 ID FROM ERP.PlanCuenta PC
WHERE PC.CuentaContable = (SELECT TOP 1 Valor FROM ERP.Parametro P WHERE Abreviatura = 'PCIGVV' AND P.IdEmpresa = @IdEmpresa) AND PC.IdEmpresa = @IdEmpresa
AND IdAnio = (SELECT ID FROM Maestro.Anio WHERE Nombre = YEAR(@Fecha))
)

RETURN @IdPlanCuenta

END