
CREATE PROC [ERP].[Usp_Validar_NumeroCheque] --1,76,1,1
@IdEmpresa INT,
@IdMovimiento INT,
@IdTalonario INT,
@NumeroCheque INT
AS
BEGIN
	
	DECLARE @Existe_Cheque INT = (SELECT COUNT(ID) FROM ERP.MovimientoTesoreria 
								  WHERE IdTalonario = 1 AND NumeroCheque = @NumeroCheque AND IdEmpresa = @IdEmpresa AND ID != @IdMovimiento
								  AND Flag = 1 AND FlagBorrador = 0) 
	
	IF @Existe_Cheque > 0 -- NO EXISTE
	BEGIN
		SELECT 1
	END
	ELSE
	BEGIN
		SELECT 2
	END

END
