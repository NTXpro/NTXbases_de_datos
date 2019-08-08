
CREATE PROC [ERP].[Usp_Upd_GuiaRemision_Reprocesar_Emitir]
@IdGuiaRemision INT,
@RutaDocumentoXML VARCHAR(MAX),
@RutaDocumentoCDR VARCHAR(MAX),
@RutaDocumentoPDF VARCHAR(MAX),
@CodigoHash VARCHAR(MAX),
@SignatureValue VARCHAR(MAX),
@XMLVale XML,
@DataResult VARCHAR(MAX) OUT
AS
BEGIN

	SET @DataResult = '';
	DECLARE @IdVale INT = ISNULL((SELECT IdVale FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision),0);
	DECLARE @FlagValidarStock BIT = (SELECT FlagValidarStock FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision);

	IF (@FlagValidarStock = 1) 
	BEGIN
		EXEC [ERP].[Usp_Upd_Vale] @IdVale,@DataResult OUT, @XMLVale
	END

	IF(LEN(@DataResult) = 0)
	BEGIN
		SELECT @IdGuiaRemision
	END
	ELSE
	BEGIN
		SELECT -1
	END

END
