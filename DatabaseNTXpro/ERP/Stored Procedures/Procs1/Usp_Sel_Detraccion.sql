
CREATE PROC [ERP].[Usp_Sel_Detraccion] 
AS
BEGIN		

		SELECT	DE.ID,
				DE.Nombre,
				DE.CodigoSunat,
				DE.Anexo,
				DE.Orden,
				DE.Porcentaje
		FROM [Maestro].[Detraccion] DE
END