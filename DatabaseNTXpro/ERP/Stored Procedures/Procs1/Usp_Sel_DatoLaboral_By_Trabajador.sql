CREATE PROC [ERP].[Usp_Sel_DatoLaboral_By_Trabajador]
@IdTrabajador INT,
@IdEmpresa INT
AS
BEGIN
		SELECT TOP 1
			   DL.ID,
			   DL.IdEmpresa,
			   DL.IdTrabajador,
			   DL.FechaInicio,
			   DL.FechaCese,
			   DL.FlagAsignacionFamiliar,
			   DL.FechaInicioAsignacionFamiliar,
			   DL.FechaFinAsignacionFamiliar
		FROM ERP.DatoLaboral DL
		LEFT JOIN ERP.Trabajador TR ON TR.ID = DL.IdTrabajador
		WHERE DL.IdEmpresa = @IdEmpresa AND DL.IdTrabajador = @IdTrabajador
		ORDER BY DL.ID DESC
END
