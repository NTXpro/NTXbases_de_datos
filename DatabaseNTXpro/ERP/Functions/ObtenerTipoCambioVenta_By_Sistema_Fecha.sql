

CREATE FUNCTION [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha](
@SistemaTipoCambio VARCHAR(20),
@Fecha DATETIME
)
RETURNS DECIMAL(10,5)
AS
BEGIN

DECLARE @TipoCambioVenta DECIMAL(10,5);
DECLARE @IdTipoCambio  INT = (	SELECT TOP 1 ID FROM ERP.TipoCambioDiario
								WHERE CAST(Fecha AS DATE) = CAST(@Fecha AS DATE))
						
IF	@IdTipoCambio IS NULL 
BEGIN
	SET @IdTipoCambio = (SELECT TOP 1 ID FROM ERP.TipoCambioDiario WHERE Fecha = 
	(SELECT TOP 1 Fecha FROM ERP.TipoCambioDiario WHERE CAST(Fecha AS DATE) < CAST(@Fecha AS DATE) ORDER BY Fecha DESC))
END


IF UPPER(@SistemaTipoCambio) = 'SUNAT'
	BEGIN
		SET @TipoCambioVenta = (SELECT VentaSunat FROM ERP.TipoCambioDiario WHERE ID = @IdTipoCambio)
	END
ELSE IF UPPER(@SistemaTipoCambio) = 'SBS'
	BEGIN
		SET @TipoCambioVenta = (SELECT VentaSBS FROM ERP.TipoCambioDiario WHERE ID = @IdTipoCambio)
	END
IF UPPER(@SistemaTipoCambio) = 'TCV'
	BEGIN
		SET @TipoCambioVenta = (SELECT VentaSunat FROM ERP.TipoCambioDiario WHERE ID = @IdTipoCambio)
	END
ELSE 
	BEGIN
		SET @TipoCambioVenta = (SELECT VentaComercial FROM ERP.TipoCambioDiario WHERE ID = @IdTipoCambio)
	END

	RETURN ISNULL(@TipoCambioVenta,0)
END
