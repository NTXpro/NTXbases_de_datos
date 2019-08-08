--LOG MODIFICACIONES
-- =============================================
-- Author:		omar rodriguez
-- Create date: 23-06-2018 4:59pm
-- tablas/sp: MAESTRO
-- Description: Se agrego una columna adicional PERIODO en base a requerimiento NRO:
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Sel_Parametro_Export]
 @Flag bit,
 @IdEmpresa int
 AS
 BEGIN
SELECT PA.ID
	,PA.Nombre NombreParametro
	,PA.Abreviatura Abreviatura
	,PA.Valor Valor
	,M.Nombre  +' ' + A.Nombre Periodo	
	,TPA.Nombre NombreTipoParametro
FROM [ERP].[Parametro] PA
INNER JOIN [ERP].[Periodo] PE ON PE.ID = PA.IdPeriodo
INNER JOIN [Maestro].[TipoParametro] TPA ON TPA.ID = PA.IdTipoParametro
INNER JOIN Maestro.Anio A ON A.ID = PE.IdAnio
INNER JOIN Maestro.Mes M ON M.ID = PE.IdMes
WHERE PA.Flag = @Flag
	AND PA.IdEmpresa = @IdEmpresa
END