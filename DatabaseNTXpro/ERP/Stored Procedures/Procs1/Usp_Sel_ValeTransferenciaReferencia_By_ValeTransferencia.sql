CREATE PROC [ERP].[Usp_Sel_ValeTransferenciaReferencia_By_ValeTransferencia]
@IdValeTransferencia INT
AS
BEGIN

	SELECT CR.ID IdComprobante,
		   CR.IdReferenciaOrigen,
		   CR.IdReferencia,
		   TC.Nombre NombreTipoComprobante,
		   CR.IdTipoComprobante,
		   CR.Serie,
		   CR.Documento,
		   CR.FlagInterno
	FROM ERP.ValeTransferenciaReferencia CR
	LEFT JOIN Maestro.ReferenciaOrigen RO ON RO.ID = CR.IdReferenciaOrigen
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = CR.IdTipoComprobante
	WHERE CR.IdValeTransferencia = @IdValeTransferencia		

END
