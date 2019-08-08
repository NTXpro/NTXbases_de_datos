CREATE PROC [ERP].[Usp_Upd_GuiaRemision_Emitir]
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
		IF @IdVale = 0
		BEGIN
			EXEC [ERP].[Usp_Ins_Vale] @IdVale OUT,@DataResult OUT, @XMLVale
		END
		ELSE
		BEGIN
			EXEC [ERP].[Usp_Upd_Vale] @IdVale,@DataResult OUT, @XMLVale
		END
	END

	IF(LEN(@DataResult) = 0)
	BEGIN
		
		IF @IdVale != 0
		BEGIN
				INSERT INTO ERP.ValeReferencia(IdVale, IdReferenciaOrigen, IdReferencia, IdTipoComprobante, Serie, Documento, FlagInterno) 
				SELECT @IdVale, 3, @IdGuiaRemision, IdTipoComprobante, Serie, Documento, CAST(1 AS BIT)  FROM ERP.GuiaRemision where ID = @IdGuiaRemision
		END

		UPDATE ERP.GuiaRemision
		SET IdGuiaRemisionEstado = 2, RutaDocumentoXML = @RutaDocumentoXML, CodigoHash = @CodigoHash, SignatureValue =@SignatureValue,RutaDocumentoCDR = @RutaDocumentoCDR ,RutaDocumentoPDF = @RutaDocumentoPDF, IdVale = @IdVale
		WHERE ID=@IdGuiaRemision			
		SELECT @IdGuiaRemision
	END
	ELSE
	BEGIN
		SELECT -1
	END

END