CREATE PROC [ERP].[Usp_Sel_Propiedad_Borrador_Pagination]
AS
BEGIN

	SELECT	PR.ID											ID,
			PR.Nombre										

	FROM [Maestro].[Propiedad] PR
	LEFT JOIN [PLE].[T6UnidadMedida] UM
	ON UM.ID = PR.IdUnidadMedida
	WHERE PR.FlagBorrador = 1 AND PR.FlagBorrador = 1
END
