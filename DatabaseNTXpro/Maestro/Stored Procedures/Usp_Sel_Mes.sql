CREATE PROC [Maestro].[Usp_Sel_Mes]
AS
BEGIN
	SELECT [ID]
		  ,[Nombre]
		  ,[Valor]
		  ,[FlagContabilidad]
	FROM [Maestro].[Mes]
	ORDER BY Valor
END