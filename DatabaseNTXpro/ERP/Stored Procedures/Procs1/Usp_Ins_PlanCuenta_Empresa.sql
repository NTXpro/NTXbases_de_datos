

CREATE PROC [ERP].[Usp_Ins_PlanCuenta_Empresa]
@IdEmpresa INT,
@IdEmpresaPlantilla INT
AS
BEGIN
	
	INSERT INTO ERP.PlanCuenta(	IdEmpresa, 
								IdAnio, 
								CuentaContable, 
								Nombre, 
								IdGrado, 
								IdColumnaBalance, 
								IdMoneda, 
								IdTipoCambio,
								EstadoAnalisis,
								EstadoProyecto,
								FlagBorrador,
								Flag,
								FechaRegistro)
				SELECT @IdEmpresa,  
					   PC.IdAnio, 
					   PC.CuentaContable,
					   PC.Nombre, 
					   (SELECT G.ID FROM Maestro.Grado G WHERE G.IdEmpresa = @IdEmpresa AND G.IdAnio = PC.IdAnio AND G.Nombre = (SELECT G2.Nombre FROM Maestro.Grado G2 WHERE G2.ID = PC.IdGrado )), 
					   PC.IdColumnaBalance,
					   PC.IdMoneda, 
					   PC.IdTipoCambio,
					   PC.EstadoAnalisis,
					   PC.EstadoProyecto,
					   PC.FlagBorrador,
					   PC.Flag,
					   PC.FechaRegistro
				FROM ERP.PlanCuenta PC WHERE PC.IdEmpresa = @IdEmpresaPlantilla AND PC.FlagBorrador = 0 AND PC.Flag = 1
	
END
