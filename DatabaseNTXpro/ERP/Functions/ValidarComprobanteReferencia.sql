

CREATE FUNCTION [ERP].[ValidarComprobanteReferencia](
@IdComprobanteReferencia int
)
RETURNS BIT
AS
BEGIN
	DECLARE @COUNT_COMPROBANTEREF INT = 0
	DECLARE @RESULT BIT

	SET @COUNT_COMPROBANTEREF =	(SELECT COUNT(CRI.ID) 
									FROM ERP.ComprobanteReferenciaInterno CRI INNER JOIN ERP.Comprobante C
										ON C.ID = CRI.IdComprobante
									WHERE C.IdTipoComprobante IN (8,9) AND C.FlagBorrador = 0 AND CRI.IdComprobanteReferencia = @IdComprobanteReferencia)

	IF ISNULL(@COUNT_COMPROBANTEREF,0) > 0
		BEGIN
			SET @RESULT = CAST(1 AS BIT)
		END
	ELSE
		BEGIN
			SET @RESULT = CAST(0 AS BIT)
		END

	RETURN @RESULT
END


