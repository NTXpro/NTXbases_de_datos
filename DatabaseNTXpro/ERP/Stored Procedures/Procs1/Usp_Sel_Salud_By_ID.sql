CREATE PROC [ERP].[Usp_Sel_Salud_By_ID]
@IdSalud INT
AS
BEGIN

	DECLARE @ID_DATO_LABORAL INT = (SELECT TOP 1 IdDatoLaboral FROM ERP.DatoLaboralSalud WHERE ID = @IdSalud);
	DECLARE @ID_EMPRESA INT = (SELECT TOP 1 IdEmpresa FROM ERP.DatoLaboralSalud WHERE ID = @IdSalud);
	DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.DatoLaboralSalud
							WHERE IdEmpresa = @ID_EMPRESA AND IdDatoLaboral = @ID_DATO_LABORAL
							ORDER BY ID DESC);
	SELECT
		SA.ID,
		SA.IdRegimenSalud,
		SA.IdDatoLaboral,
		SA.IdEmpresa,
		SA.FechaInicio,
		SA.FechaFin,
		RS.Nombre AS NombreRegimenSalud,
		RS.CodigoSunat,
		SA.IdEntidadPrestadoraDeSalud,
		E.Nombre NombreEntidadPrestadoraDeSalud,
		CASE WHEN SA.ID = @LAST_ID THEN 1 ELSE 0 END AS FlagEdit
	FROM ERP.DatoLaboralSalud SA
	INNER JOIN PLAME.T32RegimenSalud RS ON RS.ID = SA.IdRegimenSalud
	LEFT JOIN [PLAME].[T14EntidadPrestadorasDeSalud] EPS ON EPS.ID = SA.IdEntidadPrestadoraDeSalud
	LEFT JOIN ERP.Entidad E ON E.ID = EPS.IdEntidad
	WHERE SA.ID = @IdSalud
END
