CREATE PROC [ERP].[Usp_Sel_Proyecto_Unico_Secundario]
@IdEmpresa INT
AS
BEGIN
		
	SELECT	PRO.ID,
			PRO.Nombre,
			PRO.Numero,
			PRO.FechaInicio,
			PRO.FechaFin,
			PRO.FechaEliminado
	FROM [ERP].[Proyecto] PRO
		INNER JOIN ERP.Empresa EM ON EM.ID=PRO.IdEmpresa
	WHERE PRO.Flag = 1 AND PRO.FlagBorrador = 0 AND FlagCierre = 0
	AND PRO.IdTipoProyecto IN (1, 3) AND PRO.IdEmpresa = @IdEmpresa

END