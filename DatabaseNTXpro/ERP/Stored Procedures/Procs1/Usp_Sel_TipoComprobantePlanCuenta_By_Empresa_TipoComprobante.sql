
CREATE PROC [ERP].[Usp_Sel_TipoComprobantePlanCuenta_By_Empresa_TipoComprobante]
@IdEmpresa INT,
@IdTipoComprobante INT,
@IdAnio INT
AS
BEGIN
	SELECT TCPC.ID,
		   TCPC.IdTipoComprobante,
		   TCPC.IdTipoRelacion,
		   TCPC.IdMoneda,
		   TCPC.IdPlanCuenta,
		   TCPC.IdSistema,
		   PC.CuentaContable + ' '+PC.Nombre as Nombre
	FROM ERP.TipoComprobantePlanCuenta TCPC
	INNER JOIN ERP.PlanCuenta PC ON PC.ID = TCPC.IdPlanCuenta
	WHERE TCPC.IdEmpresa = @IdEmpresa AND TCPC.IdTipoComprobante = @IdTipoComprobante AND TCPC.IdAnio = @IdAnio
END