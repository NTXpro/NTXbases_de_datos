
CREATE FUNCTION [ERP].[ObtenerPlanCuentaAsientoByFecha](
@IdPlanCuenta INT,
@Fecha DATETIME,
@IdEmpresa INT
)
RETURNS VARCHAR(20)
AS
BEGIN

DECLARE @CuentaContable VARCHAR(20) = (SELECT top 1 CuentaContable FROM ERP.PlanCuenta PC WHERE PC.ID = @IdPlanCuenta)
DECLARE @IdAnio INT = (SELECT ID FROM Maestro.Anio WHERE Nombre = YEAR(@Fecha))
DECLARE @IdPlanCuentaByFecha INT = (SELECT top 1 ID FROM ERP.PlanCuenta WHERE CuentaContable = @CuentaContable AND IdAnio = @IdAnio AND IdEmpresa = @IdEmpresa)

RETURN @IdPlanCuentaByFecha

END
