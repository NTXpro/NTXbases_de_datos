
CREATE PROC [ERP].[Usp_Sel_TipoComprobantePlanCuenta_By_Sistema]
@IdEmpresa INT,
@IdSistema INT
AS
BEGIN
	SELECT	TCPC.ID,
			TCPC.IdTipoComprobante,
			TCPC.IdTipoRelacion,
			TCPC.IdMoneda,
			TCPC.IdPlanCuenta,
			PC.CuentaContable,
			TCPC.IdSistema,
			TCPC.Nombre	
	FROM ERP.TipoComprobantePlanCuenta TCPC
	INNER JOIN ERP.PlanCuenta PC ON PC.ID = TCPC.IdPlanCuenta
	WHERE TCPC.IdEmpresa = @IdEmpresa AND TCPC.IdSistema = @IdSistema
END 