

create PROC [ERP].[Usp_Sel_Cotizacion_Emitida_By_IdCliente]
@IdEmpresa INT,
@IdCliente INT,
@Serie VARCHAR(4),
@Documento VARCHAR(8)
AS
BEGIN
	SELECT	C.ID,
			C.Serie,
			C.Documento,
			C.Total,
			TC.Nombre NombreTipoComprobante
	FROM ERP.Cotizacion C
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = C.IdTipoComprobante
	WHERE C.IdEmpresa = @IdEmpresa AND C.IdCliente = @IdCliente 
	 AND (@Serie = '' OR C.Serie = @Serie) AND (@Documento = '' OR C.Documento = @Documento)
	AND C.IdCotizacionEstado = 2
END
