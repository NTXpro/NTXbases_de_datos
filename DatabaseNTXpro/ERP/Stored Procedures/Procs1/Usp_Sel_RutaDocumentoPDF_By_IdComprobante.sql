
CREATE PROC [ERP].[Usp_Sel_RutaDocumentoPDF_By_IdComprobante]
@IdComprobante INT
AS
BEGIN
	
	DECLARE @RutaDocumentoPDF VARCHAR(250) = (SELECT RutaDocumentoPDF 
												FROM ERP.Comprobante 
												WHERE ID = @IdComprobante)

	SELECT @RutaDocumentoPDF
END