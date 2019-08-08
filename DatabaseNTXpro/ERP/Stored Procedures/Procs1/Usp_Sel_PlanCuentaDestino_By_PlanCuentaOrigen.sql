CREATE PROC [ERP].[Usp_Sel_PlanCuentaDestino_By_PlanCuentaOrigen]
@IdPlanCuentaOrigen INT 
AS
BEGIN

				SELECT PCD.ID,
					   PCD.IdPlanCuentaOrigen,
					   PCD.IdPlanCuentaDestino1,
					   PC1.Nombre    PlanCuentaDestino1,
					   PCD.IdPlanCuentaDestino2,
					   PC2.Nombre	PlanCuentaDestino2,
					   PCD.Porcentaje,
					   PCD.IdEmpresa
				FROM ERP.PlanCuentaDestino PCD
				INNER JOIN ERP.PlanCuenta PC1
				ON PC1.ID = PCD.IdPlanCuentaDestino1
				INNER JOIN ERP.PlanCuenta PC2
				ON PC2.ID = PCD.IdPlanCuentaDestino2
				WHERE IdPlanCuentaOrigen = @IdPlanCuentaOrigen
END
