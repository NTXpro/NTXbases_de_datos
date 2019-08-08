CREATE PROCEDURE [ERP].[Usp_Sel_ImportacionReferencia_By_IdImportacion] --121
@ID INT
AS
BEGIN
	SELECT
		IFE.ID,
		IFE.IdImportacion,
		IFE.IdReferenciaOrigen,
		IFE.IdReferencia,
		IFE.IdTipoComprobante,
		IFE.Serie,
		IFE.Documento,
		IFE.FlagInterno,
		UPPER(TC.Abreviatura) AS AbreviaturaTipoComprobante
	FROM [ERP].[ImportacionReferencia] IFE
	LEFT JOIN PLE.T10TipoComprobante TC ON IFE.IdTipoComprobante = TC.ID
	WHERE IFE.IdImportacion = @ID
END
