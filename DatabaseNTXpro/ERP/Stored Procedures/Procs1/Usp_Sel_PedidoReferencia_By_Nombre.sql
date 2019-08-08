create PROC [ERP].[Usp_Sel_PedidoReferencia_By_Nombre]
@Documento VARCHAR(50)
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
	FROM ERP.PedidoReferencia CR
	LEFT JOIN Maestro.ReferenciaOrigen RO ON RO.ID = CR.IdReferenciaOrigen
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = CR.IdTipoComprobante
	WHERE CR.Documento = @Documento		
END