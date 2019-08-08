CREATE PROC [ERP].[Usp_Sel_Existencia_Borrador_Pagination]
AS
BEGIN

	SELECT EX.ID,
			 EX.Nombre,
			 EX.CodigoSunat,
		   EX.FechaRegistro,
		   EX.FechaEliminado
		  
	FROM [PLE].[T5Existencia] EX
	WHERE EX.FlagBorrador = 1
END
