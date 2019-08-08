CREATE PROC [Maestro].[Usp_Sel_Mes_Periodo_By_Anio]
@IdAnio INT
AS
BEGIN
	SELECT DISTINCT M.ID,
					M.Nombre,
					P.ID IdPeriodo,
					M.Valor
	FROM Maestro.Mes M INNER JOIN ERP.Periodo P
		ON M.ID = P.IdMes
	WHERE P.IdAnio = @IdAnio
	AND M.FlagContabilidad <> 1
	
END