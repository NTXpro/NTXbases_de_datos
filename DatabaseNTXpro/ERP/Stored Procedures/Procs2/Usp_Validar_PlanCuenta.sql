
CREATE PROC [ERP].[Usp_Validar_PlanCuenta] 
@CuentaContable VARCHAR(250),
@Nombre VARCHAR(250),
@IdEmpresa INT,
@IdAnio INT,
@IdPlanCuenta INT
AS
BEGIN

		SELECT COUNT(*)
		FROM ERP.PlanCuenta PC
		WHERE PC.ID !=@IdPlanCuenta  AND PC.CuentaContable = @CuentaContable AND PC.IdAnio = @IdAnio AND PC.IdEmpresa = @IdEmpresa AND PC.Flag = 1 AND PC.FlagBorrador = 0 


END
