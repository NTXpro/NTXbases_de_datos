CREATE PROC [ERP].[Usp_Sel_DatoLaboral_By_Liquidacion]
@IdEmpresa INT,
@FechaInicio DATETIME,
@FechaFin DATETIME
AS
BEGIN
	SELECT	DL.ID,
			DL.FechaInicio,
			DL.FechaCese,
			(SELECT [ERP].[ObtenerSueldoDatoLaboralByFecha](DL.ID, DL.FechaCese)) Sueldo
	FROM ERP.DatoLaboral DL
	WHERE CAST(@FechaInicio AS DATE) <= CAST(DL.FechaCese AS DATE) 
	AND CAST(DL.FechaCese AS DATE) <= CAST(@FechaFin AS DATE)
	AND DL.IdEmpresa = @IdEmpresa
END
