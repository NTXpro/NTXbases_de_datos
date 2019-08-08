CREATE PROC [ERP].[Usp_Sel_Proyecto_Export]
@Flag BIT ,
@IdEmpresa INT
AS
BEGIN
		SELECT PRO.ID,
			PRO.Nombre			Nombre,
			PRO.Numero			Numero,
			PRO.FechaInicio,
			PRO.FechaFin       FechaFin,
			PRO.FechaEliminado
		FROM [ERP].[Proyecto] PRO
		INNER JOIN ERP.Empresa EM
		ON EM.ID=PRO.IdEmpresa
		WHERE PRO.Flag = @Flag AND PRO.FlagBorrador = 0 AND PRO.IdEmpresa = @IdEmpresa
END
