CREATE PROC [ERP].[Usp_Sel_Existencia_Sunat]
AS
BEGIN
		SELECT Nombre,	
				CodigoSunat
		FROM [PLE].[T5Existencia]
		WHERE Flag=1 AND FlagBorrador = 0 AND FlagSunat=1

END
