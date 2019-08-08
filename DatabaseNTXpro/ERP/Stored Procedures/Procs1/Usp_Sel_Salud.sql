
CREATE PROC [ERP].[Usp_Sel_Salud]
@IdDatoLaboral INT,
@IdEmpresa INT
AS
BEGIN

	DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.DatoLaboralSalud
							WHERE IdEmpresa = @IdEmpresa AND IdDatoLaboral = @IdDatoLaboral
							ORDER BY ID DESC)
	SELECT
		SA.ID,
		SA.IdRegimenSalud,
		SA.IdDatoLaboral,
		SA.IdEmpresa,
		SA.FechaInicio,
		SA.FechaFin,
		RS.Nombre AS NombreRegimenSalud,
		RS.CodigoSunat,
		CASE WHEN SA.ID = @LAST_ID THEN 1 ELSE 0 END AS FlagDelete
	FROM ERP.DatoLaboralSalud SA
	INNER JOIN PLAME.T32RegimenSalud RS ON RS.ID = SA.IdRegimenSalud
	WHERE SA.IdDatoLaboral = @IdDatoLaboral AND SA.IdEmpresa = @IdEmpresa

END
