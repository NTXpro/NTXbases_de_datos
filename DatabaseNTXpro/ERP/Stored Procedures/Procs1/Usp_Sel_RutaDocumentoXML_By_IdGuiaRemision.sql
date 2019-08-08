CREATE PROC ERP.Usp_Sel_RutaDocumentoXML_By_IdGuiaRemision
@IdGuiaRemision INT
AS
BEGIN

	DECLARE @RutaDocumentoXML VARCHAR(250) = (SELECT RutaDocumentoXML 
												FROM ERP.GuiaRemision 
												WHERE ID = @IdGuiaRemision)

	SELECT @RutaDocumentoXML
END
