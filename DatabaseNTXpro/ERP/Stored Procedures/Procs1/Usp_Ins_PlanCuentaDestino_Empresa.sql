
CREATE PROC [ERP].[Usp_Ins_PlanCuentaDestino_Empresa]
@IdEmpresa INT,
@IdEmpresaPlantilla INT
AS
BEGIN
		DECLARE @TABLEDESTINO TABLE (
					IdPlanCuentaOrigen INT,
					IdPlanCuentaDestino1 INT,
					IdPlanCuentaDestino2 INT,
					Porcentaje DECIMAL(14,5))

		INSERT INTO @TABLEDESTINO (
							IdPlanCuentaOrigen,
							IdPlanCuentaDestino1,
							IdPlanCuentaDestino2,
							Porcentaje)
							SELECT
							(SELECT PC.ID FROM ERP.PlanCuenta PC WHERE  PC.IdEmpresa = @IdEmpresa AND PC.CuentaContable = PPD.CuentaContable AND PC.IdAnio = PPD.IdAnio) AS IdPlanCuentaOrigen,
							(SELECT PC.ID FROM ERP.PlanCuenta PC WHERE  PC.IdEmpresa = @IdEmpresa AND PC.CuentaContable = PPD1.CuentaContable  AND PC.IdAnio = PPD1.IdAnio) AS IdPlanCuentaDestino1,
							(SELECT PC.ID FROM ERP.PlanCuenta PC WHERE  PC.IdEmpresa = @IdEmpresa AND PC.CuentaContable = PPD2.CuentaContable  AND PC.IdAnio = PPD2.IdAnio) AS IdPlanCuentaDestino2,
							100
							FROM ERP.PlanCuentaDestino PCD
							INNER JOIN ERP.PlanCuenta PPD ON PPD.ID = PCD.IdPlanCuentaOrigen 
							INNER JOIN ERP.PlanCuenta PPD1 ON PPD1.ID = PCD.IdPlanCuentaDestino1
							INNER JOIN ERP.PlanCuenta PPD2 ON PPD2.ID = PCD.IdPlanCuentaDestino2
							WHERE PCD.IdEmpresa = @IdEmpresaPlantilla 
							AND PPD.Flag = 1 AND PPD.FlagBorrador = 0
							AND PPD1.Flag = 1 AND PPD1.FlagBorrador = 0
							AND PPD2.Flag = 1 AND PPD2.FlagBorrador = 0

		INSERT INTO ERP.PlanCuentaDestino(
											IdPlanCuentaOrigen,
											IdPlanCuentaDestino1,
											IdPlanCuentaDestino2,
											Porcentaje,
											IdEmpresa
										  )
										 SELECT 
												TD.IdPlanCuentaOrigen,
												TD.IdPlanCuentaDestino1,
												TD.IdPlanCuentaDestino2,
												TD.Porcentaje,
												@IdEmpresa
										 FROM @TABLEDESTINO TD

END
