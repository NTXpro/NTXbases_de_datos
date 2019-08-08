CREATE PROC [ERP].[Usp_Sel_GuiaRemisionReferencia_By_GuiaRemision]
@IdGuiaRemision INT
AS
BEGIN
	
	SELECT GR.ID IdComprobante,
		   GR.IdReferenciaOrigen,
		   GR.IdReferencia,
		   TC.Nombre NombreTipoComprobante,
		   GR.IdTipoComprobante,
		   GR.Serie,
		   GR.Documento,
		   GR.FlagInterno
	FROM ERP.GuiaRemisionReferencia GR
	LEFT JOIN Maestro.ReferenciaOrigen RO ON RO.ID = GR.IdReferenciaOrigen
	INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = GR.IdTipoComprobante
	WHERE GR.IdGuiaRemision = @IdGuiaRemision		
END