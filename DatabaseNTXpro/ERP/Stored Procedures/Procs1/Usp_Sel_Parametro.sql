
CREATE PROC [ERP].[Usp_Sel_Parametro]
AS
BEGIN

	SELECT	PA.ID,											
			PA.Nombre,										
			PA.Abreviatura,									
			PA.Valor									
			--TPA.Nombre,										
												
	FROM [ERP].[Parametro] PA
	INNER JOIN [ERP].[Periodo] PE
	ON PE.ID=PA.IdPeriodo
	INNER JOIN [Maestro].[TipoParametro] TPA
	ON TPA.ID=PA.IdTipoParametro
END
