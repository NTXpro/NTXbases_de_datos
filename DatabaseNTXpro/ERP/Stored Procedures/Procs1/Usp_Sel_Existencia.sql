
CREATE PROC [ERP].[Usp_Sel_Existencia]
AS
BEGIN
		
	SELECT EX.ID,
		   EX.FechaRegistro,
		   EX.FechaEliminado,
		   EX.Nombre,
		   EX.CodigoSunat
	FROM [PLE].[T5Existencia] EX
	WHERE EX.Flag = 1 AND EX.FlagBorrador = 0

END
