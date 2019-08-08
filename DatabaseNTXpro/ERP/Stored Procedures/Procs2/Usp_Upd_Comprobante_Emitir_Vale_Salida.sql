
CREATE PROC [ERP].[Usp_Upd_Comprobante_Emitir_Vale_Salida]
@IdComprobante INT,

@DataResult VARCHAR(MAX) OUT,
@XMLVale		 XML
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET @DataResult = '';
	DECLARE @IdAsiento INT = 0;
	DECLARE @IdVale INT = 0
	DECLARE @FlagGenerarVale BIT = (SELECT FlagGenerarVale FROM ERP.Comprobante WHERE ID = @IdComprobante);
	DECLARE @FlagControlarStock BIT = (SELECT FlagControlarStock FROM ERP.Comprobante WHERE ID = @IdComprobante);

	IF  @FlagGenerarVale=0 or @FlagGenerarVale=1
	BEGIN
		EXEC [ERP].[Usp_Ins_Vale] @IdVale OUT,@DataResult OUT, @XMLVale
	END
	
	IF(LEN(@DataResult) = 0)
	BEGIN
		
		IF @IdVale != 0
		BEGIN
				INSERT INTO ERP.ValeReferencia(IdVale, IdReferenciaOrigen, IdReferencia, IdTipoComprobante, Serie, Documento, FlagInterno) 
				SELECT @IdVale, 1, @IdComprobante, IdTipoComprobante, Serie, Documento, CAST(1 AS BIT)  FROM ERP.Comprobante where ID = @IdComprobante
		END

		UPDATE ERP.Comprobante SET  IdVale = @IdVale  WHERE ID = @IdComprobante				
		SELECT @IdComprobante
		
	END
	
	

	

	
	
	
	
END

update erp.comprobante set @FlagGenerarVale=1