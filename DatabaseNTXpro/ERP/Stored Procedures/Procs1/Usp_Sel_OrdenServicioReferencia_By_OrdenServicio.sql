
CREATE PROC [ERP].[Usp_Sel_OrdenServicioReferencia_By_OrdenServicio]
@IdOrdenServicio INT
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
	FROM ERP.OrdenServicioReferencia CR
	LEFT JOIN Maestro.ReferenciaOrigen RO ON RO.ID = CR.IdReferenciaOrigen
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = CR.IdTipoComprobante
	WHERE CR.IdOrdenServicio = @IdOrdenServicio	
END