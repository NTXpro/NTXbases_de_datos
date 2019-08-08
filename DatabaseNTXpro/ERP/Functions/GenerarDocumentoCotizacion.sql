
CREATE FUNCTION [ERP].[GenerarDocumentoCotizacion](
@Serie			VARCHAR(4),
@IdCotizacion	INT,
@IdEmpresa		INT
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @Documento VARCHAR(20) = (SELECT Documento FROM ERP.Cotizacion WHERE ID = @IdCotizacion AND IdEmpresa = @IdEmpresa)
	DECLARE @IdTipoComprobante INT = (SELECT IdTipoComprobante FROM ERP.Cotizacion WHERE ID = @IdCotizacion AND IdEmpresa = @IdEmpresa)
	DECLARE @UltimoCorrelativoGenerado INT= (SELECT MAX(CAST(Documento AS INT)) FROM ERP.Cotizacion WHERE Serie = @Serie AND IdEmpresa = @IdEmpresa AND IdTipoComprobante = @IdTipoComprobante AND FlagBorrador = 0)
	
	IF @Documento IS NULL OR @Documento = '' OR @Documento = '00000000'
		BEGIN
			IF @UltimoCorrelativoGenerado IS NULL 
				BEGIN
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(1)), 8)
				END
			ELSE
				BEGIN
					SET @UltimoCorrelativoGenerado = @UltimoCorrelativoGenerado + 1
					SET @Documento = RIGHT('00000000' + LTRIM(RTRIM(@UltimoCorrelativoGenerado)), 8)
				END
		END
	
	RETURN 	@Documento

END
