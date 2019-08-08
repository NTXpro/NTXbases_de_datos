
CREATE PROC [ERP].[Usp_Sel_OrdenCompraReferencia_By_OrdenCompra]
@IdOrdenCompra INT
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
	FROM ERP.OrdenCompraReferencia CR
	LEFT JOIN Maestro.ReferenciaOrigen RO ON RO.ID = CR.IdReferenciaOrigen
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = CR.IdTipoComprobante
	WHERE CR.IdOrdenCompra = @IdOrdenCompra		
END
