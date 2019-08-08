CREATE PROC [ERP].[Usp_ObtenerPlanCuentaByOperacion] --1
@IdOperacion INT
AS
BEGIN
	
		SELECT PC.ID,
			   PC.CuentaContable,
			   PC.Nombre,
			   PC.CuentaContable + ' ' +PC.Nombre  NombreCompleto
		FROM ERP.Operacion OP
		INNER JOIN ERP.PlanCuenta PC
		ON PC.ID = OP.IdPlanCuenta
		WHERE OP.ID = @IdOperacion
END
