CREATE FUNCTION ERP.ObtenerTipoCambioCompra_By_Sistema_Fecha(
@SistemaTipoCambio VARCHAR(20),
@Fecha DATETIME
)
RETURNS DECIMAL(10,5)
AS
BEGIN

DECLARE @TipoCambioCompra DECIMAL(10,5);
DECLARE @IdTipoCambio  INT = (	SELECT TOP 1 ID FROM ERP.TipoCambioDiario
								WHERE CAST(Fecha AS DATE) = CAST(@Fecha AS DATE))
						
IF	@IdTipoCambio IS NULL 
BEGIN
	SET @IdTipoCambio = (SELECT TOP 1 ID FROM ERP.TipoCambioDiario WHERE Fecha = 
	(SELECT TOP 1 Fecha FROM ERP.TipoCambioDiario WHERE CAST(Fecha AS DATE) < CAST(@Fecha AS DATE) ORDER BY Fecha DESC))
END


IF UPPER(@SistemaTipoCambio) = 'SUNAT'
	BEGIN
		SET @TipoCambioCompra = (SELECT CompraSunat FROM ERP.TipoCambioDiario WHERE ID = @IdTipoCambio)
	END
ELSE IF UPPER(@SistemaTipoCambio) = 'SBS'
	BEGIN
		SET @TipoCambioCompra = (SELECT CompraSBS FROM ERP.TipoCambioDiario WHERE ID = @IdTipoCambio)
	END
ELSE 
	BEGIN
		SET @TipoCambioCompra = (SELECT CompraComercial FROM ERP.TipoCambioDiario WHERE ID = @IdTipoCambio)
	END

	RETURN ISNULL(@TipoCambioCompra,0)
END
