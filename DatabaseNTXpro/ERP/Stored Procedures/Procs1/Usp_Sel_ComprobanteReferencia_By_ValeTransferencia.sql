
CREATE PROC [ERP].[Usp_Sel_ComprobanteReferencia_By_ValeTransferencia]
@IdTransferencia INT
AS
BEGIN
	
	SELECT C.ID,
		   C.IdTipoComprobante,
		   TC.Nombre NombreTipoComprobante,
		   C.Serie,
		   C.Documento,
		   CAST(1 AS INT) IdTipoComprobanteReferencia
	FROM ERP.ValeTransferenciaReferenciaInterno CR 
	INNER JOIN ERP.Comprobante C
		ON C.ID = CR.IdComprobanteReferencia
	INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = C.IdTipoComprobante
	WHERE CR.IdValeTransferencia = @IdTransferencia

	UNION 

	SELECT CAST(0 AS INT) ID,
		   CR.IdTipoComprobante,
		   TC.Nombre NombreTipoComprobante,
		   CR.SerieReferencia Serie,
		   CR.DocumentoReferencia Documento,
		   CAST(2 AS INT) IdTipoComprobanteReferencia
	FROM ERP.ValeTransferenciaReferenciaExterno CR 
	INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CR.IdTipoComprobante
	WHERE CR.IdValeTransferencia = @IdTransferencia
END
