CREATE PROCEDURE [Maestro].[Usp_Sel_TipoConcepto]
AS
BEGIN
	SELECT 
	     ID,
		 Nombre,
		 Codigo
	FROM [Maestro].[TipoConcepto]
END
