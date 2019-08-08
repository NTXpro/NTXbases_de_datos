
CREATE PROC [ERP].[Usp_Sel_Marca]
AS
BEGIN
		
	SELECT	MA.ID,
			MA.Nombre,
		   MA.FechaRegistro,
		   MA.FechaEliminado
		  
	FROM [Maestro].[Marca] MA
	WHERE MA.Flag = 1 AND MA.FlagBorrador = 0

END