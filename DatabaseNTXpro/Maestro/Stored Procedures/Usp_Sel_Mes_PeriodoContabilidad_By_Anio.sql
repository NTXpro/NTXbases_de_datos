CREATE PROC [Maestro].[Usp_Sel_Mes_PeriodoContabilidad_By_Anio]
@IdAnio INT
AS
BEGIN
	SELECT DISTINCT M.ID,
					M.Nombre,
					P.ID IdPeriodo,
					M.Valor
	FROM Maestro.Mes M 
	INNER JOIN ERP.Periodo P
		ON M.ID = P.IdMes
	WHERE P.IdAnio = @IdAnio
	Order by Valor asc
	
END