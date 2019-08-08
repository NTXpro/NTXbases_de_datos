CREATE PROC [ERP].[Usp_Sel_Propiedad]
AS
BEGIN
		
	SELECT	PR.ID,
			PR.Nombre,
			PR.FechaRegistro,
			PR.FechaEliminado,
			UM.Nombre NombreUnidadMedida,
			UM.CodigoSunat CodigoSunatUnidadMedida,
			UM.ID IdUnidadMedida
	FROM [Maestro].[Propiedad] PR
	INNER JOIN [PLE].[T6UnidadMedida] UM
	ON UM.ID = PR.IdUnidadMedida
	WHERE PR.Flag = 1 AND PR.FlagBorrador = 0

END
