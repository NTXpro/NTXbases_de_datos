CREATE PROCEDURE [Maestro].[Usp_Sel_IngresoTributoDescuento]
AS
BEGIN
	SELECT 
	     ID,
		 Nombre,
		 CodigoSunat
	FROM [PLAME].[T22IngresoTributoDescuento]
END
