
CREATE PROC [ERP].[Usp_Sel_PlanCuenta_MayorGrado]-- 1,2017
@IdEmpresa INT,
@Anio INT
AS
BEGIN
	
	declare @IdAnio INT=(SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio)

	DECLARE @MaximoValor INT = (SELECT TOP 1 MAX(G.Longitud) FROM Maestro.Grado G WHERE G.IdEmpresa = @IdEmpresa AND G.IdAnio = @IdAnio)

	SELECT PC.ID,
		   PC.Nombre,
		   PC.CuentaContable,
		   PC.EstadoProyecto,
		   PC.EstadoAnalisis
	FROM ERP.PlanCuenta PC 
	INNER JOIN Maestro.Anio AN
	ON AN.ID = PC.IdAnio
	WHERE PC.IdGrado IN (SELECT ID FROM Maestro.Grado WHERE Longitud = @MaximoValor AND IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio) AND PC.IdEmpresa=@IdEmpresa AND AN.ID = @IdAnio
	AND Flag = 1 AND FlagBorrador = 0
END