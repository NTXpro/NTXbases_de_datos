CREATE PROC [ERP].[Usp_Sel_MotivoGuiaRemision]
AS
BEGIN

	SELECT MT.ID,
		   MT.CodigoSunat,
		   MT.Nombre,
		   MT.IdTipoOperacion,
		   TM.ID IdTipoMovimiento 
	FROM XML.T20MotivoTraslado MT
	INNER JOIN PLE.T12TipoOperacion TP ON TP.ID = MT.IdTipoOperacion
	INNER JOIN Maestro.TipoMovimiento TM ON TM.ID = TP.IdTipoMovimiento
END
