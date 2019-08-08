CREATE PROC [ERP].[Usp_Sel_Pension_By_ID]
@IdPension INT
AS
BEGIN
	DECLARE @ID_TRABAJADOR INT = (SELECT TOP 1 IdTrabajador FROM ERP.TrabajadorPension WHERE ID = @IdPension);
	DECLARE @ID_EMPRESA INT = (SELECT TOP 1 IdEmpresa FROM ERP.TrabajadorPension WHERE ID = @IdPension);
	DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.TrabajadorPension
							WHERE IdEmpresa = @ID_EMPRESA AND IdTrabajador = @ID_TRABAJADOR
							ORDER BY ID DESC);
	SELECT
		PE.ID,
		PE.IdTrabajador,
		PE.IdRegimenPensionario,
		PE.IdTipoComision,
		PE.IdEmpresa,
		PE.FechaInicio,
		PE.FechaFin,
		PE.Cuspp,
		RP.Nombre AS NombreRegimenPensionario,
		TC.Nombre AS NombreTipoComision,
		RP.CodigoSunat,
		CASE WHEN PE.ID = @LAST_ID THEN 1 ELSE 0 END AS FlagEdit
	FROM ERP.TrabajadorPension PE
	INNER JOIN PLAME.T11RegimenPensionario RP ON RP.ID = PE.IdRegimenPensionario
	LEFT JOIN Maestro.TipoComision TC ON TC.ID = PE.IdTipoComision
	WHERE PE.ID = @IdPension
END
