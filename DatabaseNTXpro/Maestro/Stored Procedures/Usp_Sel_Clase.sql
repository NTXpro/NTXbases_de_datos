CREATE PROCEDURE [Maestro].[Usp_Sel_Clase]
AS
BEGIN
	SELECT 
	     ID,
		 Nombre,
		 Codigo
	FROM [Maestro].[Clase]
END
