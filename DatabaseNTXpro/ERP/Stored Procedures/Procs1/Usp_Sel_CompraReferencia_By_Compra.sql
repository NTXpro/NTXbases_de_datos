
CREATE PROC [ERP].[Usp_Sel_CompraReferencia_By_Compra]
@IdComprobante INT
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
	FROM ERP.CompraReferencia CR
	INNER JOIN Maestro.ReferenciaOrigen RO ON RO.ID = CR.IdReferenciaOrigen
	INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = CR.IdTipoComprobante
	WHERE CR.IdCompra = @IdComprobante		
END
