CREATE PROC [ERP].[Usp_Sel_Parametro_By_Empresa] --1
@IdEmpresa int
AS
BEGIN

	SELECT	ID,
			Nombre,
			Abreviatura,
			Valor 
	FROM ERP.Parametro 
	WHERE IdTipoParametro = 1 ---Sistema

	UNION 

	SELECT	ID,
			Nombre,
			Abreviatura,
			CASE WHEN Abreviatura = 'TCV' THEN
				CAST((SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema](Valor)) AS VARCHAR(50))
			ELSE
				Valor
			END Valor
	FROM ERP.Parametro 
	WHERE IdEmpresa = @IdEmpresa ---Sistema

END
