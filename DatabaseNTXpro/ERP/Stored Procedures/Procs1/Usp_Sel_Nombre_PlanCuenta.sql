CREATE PROC ERP.Usp_Sel_Nombre_PlanCuenta
@IdEmpresa INT
AS
BEGIN
	SELECT ID, CuentaContable
	FROM ERP.PlanCuenta 
	WHERE IdEmpresa = @IdEmpresa

END