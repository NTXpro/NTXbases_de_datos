
CREATE PROC [ERP].[Usp_Sel_PlanCuenta_Inactivo]
@IdEmpresa INT
AS
BEGIN
		
	SELECT	PC.ID,
			PC.CuentaContable,
			PC.Nombre,
			PC.EstadoAnalisis,
			PC.EstadoProyecto

	FROM [ERP].[PlanCuenta] PC
	INNER JOIN Maestro.Grado GR
	ON GR.ID = PC.IdGrado
	INNER JOIN Maestro.Moneda MO
	ON MO.ID = PC.IdMoneda
	INNER JOIN Maestro.TipoCambio TC
	ON TC.ID= PC.IdTipoCambio
	INNER JOIN Maestro.ColumnaBalance CB
	ON CB.ID = PC.IdColumnaBalance
	LEFT JOIN ERP.Empresa EM
	ON EM.ID = PC.IdEmpresa
	WHERE PC.Flag = 0 AND PC.FlagBorrador = 0 AND PC.IdEmpresa = @IdEmpresa

END