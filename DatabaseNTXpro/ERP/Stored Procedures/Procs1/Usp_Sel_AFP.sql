CREATE PROC [ERP].[Usp_Sel_AFP]
AS
BEGIN
	SELECT 
		A.ID,
	    A.IdEntidad,
		A.Codigo,
		A.FlagTope,
		CASE WHEN A.FlagTope = 1 THEN 'REMUNERACIÓN TOPE' ELSE E.Nombre END AS Nombre
	FROM [ERP].[AFP] A
	LEFT JOIN [ERP].[Entidad] E ON A.IdEntidad = E.ID
    WHERE
	A.Flag = 1
END
