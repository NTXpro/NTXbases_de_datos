
CREATE PROC [ERP].[Usp_Sel_Existencia_Inactivo]
AS
BEGIN
		
	SELECT EX.ID,
		   EX.FechaRegistro,
		   EX.FechaEliminado,
		   EX.Nombre,
		   EX.CodigoSunat
	FROM [PLE].[T5Existencia] EX
	WHERE EX.Flag = 0 AND EX.FlagBorrador = 0

END
