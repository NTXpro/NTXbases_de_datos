CREATE PROC [ERP].[Usp_Sel_Puesto_Sunat]

AS
BEGIN


	SELECT	
	ID IdOcupacion  ,
			(CodigoSunat + ' - ' + Nombre) AS CodigoSunat
	
		
		FROM PLAME.T10Ocupacion ORDER BY CodigoSunat DESC
			
		
	
END