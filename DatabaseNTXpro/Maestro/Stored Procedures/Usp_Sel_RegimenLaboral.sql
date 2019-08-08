CREATE PROCEDURE [Maestro].[Usp_Sel_RegimenLaboral]
AS
BEGIN
	SELECT [ID]
		,[Nombre]
		,[NombreAbreviado]
		,[CodigoSunat]
		,[FlagSectorPrivado]
		,[FlagSectorPublico]
		,[FlagOtraEntidad]
	FROM [PLAME].[T33RegimenLaboral]
END
