CREATE PROC [ERP].[Usp_Sel_Pension]
@IdTrabajador INT,
@IdEmpresa INT
AS
BEGIN
	
	DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.TrabajadorPension
							WHERE IdEmpresa = @IdEmpresa AND IdTrabajador = @IdTrabajador
							ORDER BY ID DESC)
	
	SELECT 
		PE.ID,
		PE.IdTrabajador,
		PE.IdRegimenPensionario,
		PE.IdEmpresa,
		PE.FechaInicio,
		PE.FechaFin,
		PE.Cuspp,
		RP.Nombre AS NombreRegimenPensionario,
		RP.CodigoSunat,
		CASE WHEN PE.ID = @LAST_ID THEN 1 ELSE 0 END AS FlagDelete,
		ISNULL(tc.Nombre,'') AS TipoComision
	FROM ERP.TrabajadorPension PE
	INNER JOIN PLAME.T11RegimenPensionario RP ON RP.ID = PE.IdRegimenPensionario
	INNER JOIN ERP.Trabajador TR ON TR.ID = PE.IdTrabajador
	INNER JOIN ERP.Empresa EM ON EM.ID = PE.IdEmpresa
	LEFT JOIN MAESTRO.TipoComision tc ON PE.IdTipoComision = tc.ID
	WHERE PE.IdTrabajador = @IdTrabajador AND EM.ID = @IdEmpresa
	ORDER BY PE.ID
END