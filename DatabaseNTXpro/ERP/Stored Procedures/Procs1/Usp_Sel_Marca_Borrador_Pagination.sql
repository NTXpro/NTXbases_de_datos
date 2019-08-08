CREATE PROC [ERP].[Usp_Sel_Marca_Borrador_Pagination]
AS
BEGIN

	SELECT MA.ID,
			MA.Nombre,
			
		   MA.FechaRegistro,
		   MA.FechaEliminado
		  
	FROM Maestro.Marca MA
	WHERE MA.FlagBorrador = 1
END
