
CREATE PROC [ERP].[Usp_Sel_Comprobante_By_Sistema_Consulta] --1,4,'b001','00009368','01/01/2017',2
@IdEmpresa INT,
@IdTipoComprobante INT,
@SerieComprobante VARCHAR(4),
@DocumentoComprobante VARCHAR(8),
@FechaComprobante DATETIME,
@TotalComprobante DECIMAL(14,5)
AS
BEGIN
	DECLARE @IdTipoComprobante2 INT= 0;

	IF @IdTipoComprobante = 2
	BEGIN
		SET @IdTipoComprobante2 = 190;
	END
	ELSE IF @IdTipoComprobante = 4
	BEGIN
		SET @IdTipoComprobante2 = 189;
	END

	SELECT C.ID,SerieDocumentoComprobante,RutaDocumentoXML,RutaDocumentoPDF,IdComprobanteEstado
	FROM ERP.Comprobante C
	INNER JOIN ERP.Empresa EMP
		ON EMP.ID = C.IdEmpresa
	INNER JOIN ERP.Entidad E
		ON E.ID = EMP.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = E.ID
	WHERE IdTipoComprobante IN (@IdTipoComprobante, @IdTipoComprobante2) AND Serie = @SerieComprobante AND Documento = @DocumentoComprobante
	AND CAST(Fecha AS DATE) = CAST(@FechaComprobante AS DATE) AND Total = @TotalComprobante AND C.IdEmpresa = @IdEmpresa

END
