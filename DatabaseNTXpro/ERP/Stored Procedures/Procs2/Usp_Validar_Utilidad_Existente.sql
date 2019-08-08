
CREATE PROC [ERP].[Usp_Validar_Utilidad_Existente]
@IdEmpresa INT,
@IdAnioProcesado INT
AS
BEGIN
	DECLARE @IdLiquidacion INT = (SELECT ID FROM ERP.Utilidad 
									WHERE IdEmpresa = @IdEmpresa AND IdAnioProcesado = @IdAnioProcesado)

	SELECT ISNULL(@IdLiquidacion, 0)
END
