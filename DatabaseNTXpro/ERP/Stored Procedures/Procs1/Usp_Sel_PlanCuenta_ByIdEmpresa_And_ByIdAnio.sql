CREATE PROC [ERP].[Usp_Sel_PlanCuenta_ByIdEmpresa_And_ByIdAnio]
@IdEmpresa INT,
@IdAnio INT
AS
BEGIN	
	SELECT	PC.ID,
			PC.CuentaContable,
			PC.Nombre
	FROM [ERP].[PlanCuenta] PC 
	WHERE PC.Flag = 1 AND 
	PC.FlagBorrador = 0 AND 
	PC.IdEmpresa = @IdEmpresa AND
	PC.IdAnio = @IdAnio
END