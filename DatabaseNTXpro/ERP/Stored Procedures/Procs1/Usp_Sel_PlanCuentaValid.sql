CREATE PROC [ERP].[Usp_Sel_PlanCuentaValid]
@IdEmpresa INT
AS
BEGIN
	SELECT PC.ID,
		   PC.EstadoProyecto,
		   PC.EstadoAnalisis
	FROM ERP.PlanCuenta PC WHERE PC.IdEmpresa=@IdEmpresa
END