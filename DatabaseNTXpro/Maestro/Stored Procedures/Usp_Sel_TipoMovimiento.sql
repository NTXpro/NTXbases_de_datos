
CREATE PROC [Maestro].[Usp_Sel_TipoMovimiento]
AS
BEGIN
	SELECT [ID]
		,[Nombre]
		,[Abreviatura]
	FROM [Maestro].[TipoMovimiento]
END
