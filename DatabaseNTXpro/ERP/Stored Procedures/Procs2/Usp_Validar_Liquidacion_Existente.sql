
CREATE PROC [ERP].[Usp_Validar_Liquidacion_Existente]
@IdEmpresa INT,
@IdPeriodo INT
AS
BEGIN
	DECLARE @IdLiquidacion INT = (SELECT ID FROM ERP.Liquidacion 
									WHERE IdEmpresa = @IdEmpresa AND IdPeriodo = @IdPeriodo)

	SELECT ISNULL(@IdLiquidacion, 0)
END
