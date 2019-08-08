
CREATE PROC [ERP].[Usp_Sel_Comprobante_By_Estado_Cliente]
@IdCliente INT,
@IdEstado INT,
@Serie VARCHAR(4),
@Documento VARCHAR(8)
AS
BEGIN
	SELECT	C.ID,
			C.Serie,
			C.Documento,
			C.Total,
			C.IdCliente,
			C.IdTipoComprobante,
			C.IdComprobanteEstado,
			TC.Nombre NombreTipoComprobante
	FROM ERP.Comprobante C
	INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = C.IdTipoComprobante
	WHERE C.IdCliente = @IdCliente AND C.IdComprobanteEstado = @IdEstado AND C.FlagBorrador = 0
	 AND (@Serie = '' OR C.Serie = @Serie) AND (@Documento = '' OR C.Documento = @Documento) AND C.IdTipoComprobante NOT IN (8,9)
	 ORDER BY C.Serie,C.Documento
END
