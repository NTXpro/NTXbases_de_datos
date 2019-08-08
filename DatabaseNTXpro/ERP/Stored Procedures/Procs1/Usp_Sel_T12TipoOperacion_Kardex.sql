
CREATE PROCEDURE [ERP].[Usp_Sel_T12TipoOperacion_Kardex]
AS
BEGIN
	SELECT 
	   TOPE.ID
      ,CONCAT(TM.Abreviatura, + '|' + TOPE.Nombre) AS Nombre
      ,TOPE.CodigoSunat
	FROM [PLE].[T12TipoOperacion] TOPE
	INNER JOIN Maestro.TipoMovimiento TM ON TOPE.IdTipoMovimiento = TM.ID
	WHERE 
	(TOPE.FlagBorrador = 0 OR TOPE.FlagBorrador IS NULL) AND 
	TOPE.Flag = 1 AND 
	TOPE.IdTipoMovimiento IS NOT NULL
	ORDER BY TM.ID, TOPE.ID
END
