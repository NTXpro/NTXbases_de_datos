CREATE PROC [ERP].[Usp_Sel_CotizacionReferencia_By_Cotizacion]
@IdCotizacion INT
AS
BEGIN
	
	SELECT CR.ID IdComprobante,
		   CR.IdReferenciaOrigen,
		   CR.IdReferencia,
		   TC.Nombre NombreTipoComprobante,
		   CR.IdTipoComprobante,
		   --CR.Serie,
		   IIF(CR.Serie = '0000', '', CR.Serie) Serie,
		   CR.Documento,
		   CR.FlagInterno
	FROM ERP.CotizacionReferencia CR
	LEFT JOIN Maestro.ReferenciaOrigen RO ON RO.ID = CR.IdReferenciaOrigen
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = CR.IdTipoComprobante
	WHERE CR.IdCotizacion = @IdCotizacion		
END