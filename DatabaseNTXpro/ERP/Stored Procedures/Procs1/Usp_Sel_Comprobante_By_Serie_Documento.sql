
CREATE PROC [ERP].[Usp_Sel_Comprobante_By_Serie_Documento]
@IdTipoComprobante INT,
@Serie VARCHAR(4),
@Documento VARCHAR(10),
@IdEmpresa INT
AS
BEGIN
	
	SELECT C.ID,
		   C.IdTipoComprobante,
		   TC.Nombre NombreTipoComprobante,
		   C.Serie,
		   C.Documento,
		   C.IdCliente,
		   C.IdComprobanteEstado,
		   (SELECT [ERP].[ValidarComprobanteReferencia](C.ID)) AS ComprobanteRefExistente,
		   CLI.IdEntidad
	FROM ERP.Comprobante C INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = C.IdTipoComprobante
	LEFT JOIN ERP.Cliente CLI
		ON CLI.ID = C.IdCliente
	WHERE C.IdTipoComprobante = @IdTipoComprobante AND C.Serie = @Serie AND C.Documento = @Documento
	AND C.FlagBorrador = 0 AND C.Flag = 1 AND C.IdEmpresa = @IdEmpresa

END
