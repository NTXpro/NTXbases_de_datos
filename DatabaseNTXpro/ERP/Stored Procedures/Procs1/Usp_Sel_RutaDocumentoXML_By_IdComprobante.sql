CREATE PROC ERP.Usp_Sel_RutaDocumentoXML_By_IdComprobante
@IdComprobante INT
AS
BEGIN
	
	DECLARE @RutaDocumentoXML VARCHAR(250) = (SELECT RutaDocumentoXML 
												FROM ERP.Comprobante 
												WHERE ID = @IdComprobante)

	SELECT @RutaDocumentoXML
END