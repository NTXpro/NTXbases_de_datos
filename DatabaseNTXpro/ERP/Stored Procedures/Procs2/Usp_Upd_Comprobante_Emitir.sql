CREATE PROC [ERP].[Usp_Upd_Comprobante_Emitir]
@IdComprobante INT,
@RutaDocumentoXML VARCHAR(MAX),
@RutaDocumentoPDF VARCHAR(MAX),
@RutaDocumentoCDR VARCHAR(MAX),
@CodigoHash VARCHAR(MAX),
@SignatureValue VARCHAR(MAX),
@MensajeSunat VARCHAR(MAX),
@DataResult VARCHAR(MAX) OUT,
@XMLVale		 XML
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET @DataResult = '';
	DECLARE @IdAsiento INT = 0;
	DECLARE @IdVale INT = 0
	DECLARE @IdEmpresa INT =(SELECT TOP 1  cp.IdEmpresa FROM ERP.Comprobante cp WHERE ID = @IdComprobante) 
	DECLARE @FlagGenerarVale BIT = (SELECT c.FlagGenerarVale  FROM  ERP.Comprobante c WHERE C.ID = @IdComprobante)
	DECLARE @FlagControlarStock BIT =(SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa,'VCSPF',GETDATE()))




	IF @FlagControlarStock = 1 AND @FlagGenerarVale = 1 --VALE DE SALIDA
	BEGIN
	    EXEC [ERP].[Usp_Upd_TransformacionComprobante_Manual] @PARAM_IdComprobante = @IdComprobante 
		EXEC [ERP].[Usp_Ins_Vale] @IdVale OUT,@DataResult OUT, @XMLVale
	END
	
	IF(LEN(@DataResult) = 0)
	BEGIN
		EXEC ERP.Usp_Ins_AsientoContable_Venta @IdAsiento OUT,@IdComprobante,4/*REGISTRO DE VENTAS(ORIGEN)*/,2/*VENTAS(SISTEMA)*/
		EXEC ERP.Usp_Ins_CuentaCobrar_Comprobante @IdComprobante

		IF @IdVale != 0
		BEGIN
				INSERT INTO ERP.ValeReferencia(IdVale, IdReferenciaOrigen, IdReferencia, IdTipoComprobante, Serie, Documento, FlagInterno) 
				SELECT @IdVale, 1, @IdComprobante, IdTipoComprobante, Serie, Documento, CAST(1 AS BIT)  FROM ERP.Comprobante where ID = @IdComprobante
		END

		UPDATE ERP.Comprobante
		SET IdComprobanteEstado = 2,
			RutaDocumentoXML = @RutaDocumentoXML,
			RutaDocumentoPDF = @RutaDocumentoPDF,
			IdAsiento = @IdAsiento,
			FlagBorrador = 0,
			CodigoHash = @CodigoHash,
			SignatureValue = @SignatureValue,
			RutaDocumentoCDR = @RutaDocumentoCDR,
			MensajeSunat = @MensajeSunat,
			IdVale = @IdVale 
		WHERE ID = @IdComprobante
		
		SELECT @IdComprobante
	END

	ELSE
	
	BEGIN
	
		SELECT -1
	
	END
END