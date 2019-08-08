
CREATE PROCEDURE [ERP].[Usp_Sel_EstructuraTres_By_IdDos]
@IdEstructuraDos INT
AS
BEGIN
	SELECT 
	   EBGT.ID
      ,EBGT.IdEstructuraDos
	  ,EBGU.ID AS IdEstructuraUno
      ,EBGT.Nombre
	  ,EBGT.Orden
	FROM [ERP].[EstructuraTres] EBGT
	INNER JOIN [ERP].[EstructuraDos] EBGD ON EBGT.IdEstructuraDos = EBGD.ID
	INNER JOIN [ERP].[EstructuraUno] EBGU ON EBGD.IdEstructuraUno = EBGU.ID
	WHERE
	EBGT.IdEstructuraDos = @IdEstructuraDos AND
	EBGT.Flag = 1
	ORDER BY EBGT.Orden
END
