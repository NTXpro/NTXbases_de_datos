CREATE PROC ERP.Usp_Sel_Comprobante_By_TipoComprobanteSerieDocumento
@IdTipoComprobante INT,
@Serie VARCHAR(4),
@Documento VARCHAR(8)
AS
BEGIN
	
	SELECT C.ID,
		   IdTipoComprobante,
		   Serie,
		   Documento 
	FROM ERP.Comprobante C INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = C.IdTipoComprobante
	WHERE IdTipoComprobante = @IdTipoComprobante AND Serie = @Serie AND Documento = @Documento

END