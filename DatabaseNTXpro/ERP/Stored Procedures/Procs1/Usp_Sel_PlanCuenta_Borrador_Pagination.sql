CREATE PROC [ERP].[Usp_Sel_PlanCuenta_Borrador_Pagination]
@IdEmpresa INT
AS
BEGIN

	SELECT	
			PC.ID,
			PC.Nombre,
			PC.CuentaContable,
			PC.FechaRegistro
	FROM [ERP].[PlanCuenta] PC
		LEFT JOIN Maestro.Grado GR
		ON GR.ID = PC.IdGrado
		LEFT JOIN Maestro.Moneda MO
		ON MO.ID = PC.IdMoneda
		LEFT JOIN Maestro.TipoCambio TC
		ON TC.ID= PC.IdTipoCambio
		LEFT JOIN Maestro.ColumnaBalance CB
		ON CB.ID = PC.IdColumnaBalance
		LEFT JOIN ERP.Empresa EM
		ON EM.ID = PC.IdEmpresa
	WHERE PC.FlagBorrador = 1 AND PC.IdEmpresa= @IdEmpresa
END
