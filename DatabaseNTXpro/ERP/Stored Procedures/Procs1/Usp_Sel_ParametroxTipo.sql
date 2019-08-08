CREATE PROC ERP.Usp_Sel_ParametroxTipo
AS
BEGIN
	SELECT *
	FROM [ERP].[Parametro] PA
	INNER JOIN [Maestro].[TipoParametro] TPA
	ON TPA.ID=PA.IdTipoParametro
	WHERE TPA.ID=2
END
