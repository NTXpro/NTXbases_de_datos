CREATE PROC [ERP].[Usp_Sel_UnidadMedida_Borrador_Pagination]
AS
BEGIN

	SELECT UM.ID,
			 UM.Nombre,
			 UM.CodigoSunat,
		   UM.FechaRegistro,
		   UM.FechaEliminado
		  
	FROM [PLE].[T6UnidadMedida] UM
	WHERE UM.FlagBorrador = 1
END
