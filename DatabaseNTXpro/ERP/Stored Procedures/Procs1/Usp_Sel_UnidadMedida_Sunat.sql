CREATE PROC [ERP].[Usp_Sel_UnidadMedida_Sunat]
AS
BEGIN
		SELECT Nombre,	
			   CodigoSunat
		FROM [PLE].[T6UnidadMedida]
		WHERE Flag=1 AND FlagBorrador = 0 AND FlagSunat=1

END
