CREATE PROC ERP.Usp_Validar_UltimaGuiaRemisionEmitido
@IdGuiaRemision INT
AS
BEGIN
	DECLARE @IdEmpresa INT= (SELECT IdEmpresa FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision);
	DECLARE @Serie VARCHAR(4)= (SELECT Serie FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision);
	DECLARE @Documento VARCHAR(8)= (SELECT Documento FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision);
	DECLARE @IdTipoComprobante INT= (SELECT IdTipoComprobante FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision);

	DECLARE @UltimoDocumentoPorEmitir VARCHAR(8) = (SELECT MIN(Documento) FROM ERP.GuiaRemision WHERE Serie = @Serie AND IdTipoComprobante = @IdTipoComprobante AND IdEmpresa = @IdEmpresa AND IdGuiaRemisionEstado = 1 AND Flag = 1 AND FlagBorrador = 0);
	
	IF @Documento = @UltimoDocumentoPorEmitir
	BEGIN
		SELECT CAST(0 AS BIT)
	END
	ELSE
	BEGIN
		SELECT CAST(1 AS BIT)
	END
END
