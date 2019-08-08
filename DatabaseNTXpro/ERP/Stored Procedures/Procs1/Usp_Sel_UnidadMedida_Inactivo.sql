

CREATE PROC [ERP].[Usp_Sel_UnidadMedida_Inactivo]
AS
BEGIN
		
	SELECT UM.ID,
		   UM.FechaRegistro,
		   UM.FechaEliminado,
		   UM.Nombre,
		   UM.CodigoSunat
	FROM [PLE].[T6UnidadMedida] UM
	WHERE UM.Flag = 0 AND UM.FlagBorrador = 0

END

