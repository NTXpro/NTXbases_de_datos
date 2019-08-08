CREATE PROC ERP.Usp_Validar_UltimoComprobanteEmitido --60
@IdComprobante INT
AS
BEGIN
	DECLARE @IdEmpresa INT= (SELECT IdEmpresa FROM ERP.Comprobante WHERE ID = @IdComprobante);
	DECLARE @Serie VARCHAR(4)= (SELECT Serie FROM ERP.Comprobante WHERE ID = @IdComprobante);
	DECLARE @Documento VARCHAR(8)= (SELECT Documento FROM ERP.Comprobante WHERE ID = @IdComprobante);
	DECLARE @IdTipoComprobante INT= (SELECT IdTipoComprobante FROM ERP.Comprobante WHERE ID = @IdComprobante);
	DECLARE @UltimoDocumentoPorEmitir VARCHAR(8) = (SELECT MIN(Documento) FROM ERP.Comprobante WHERE Serie = @Serie AND IdTipoComprobante = @IdTipoComprobante AND IdEmpresa = @IdEmpresa AND IdComprobanteEstado = 1 AND Flag = 1 AND FlagBorrador = 0);
	
	--SELECT @Serie,@Documento,@UltimoDocumentoPorEmitir

	IF @Documento = @UltimoDocumentoPorEmitir
	BEGIN
		SELECT CAST(0 AS BIT)
	END
	ELSE
	BEGIN
		SELECT CAST(1 AS BIT)
	END

END
