
CREATE FUNCTION [ERP].[ObtenerPlanCuentaByTipoComprobantePlanCuenta](
@IdEmpresa			INT,
@IdTipoComprobante	INT,
@IdTipoRelacion		INT,
@IdMoneda			INT,
@IdSistema			INT,
@IdAnio				INT
)
RETURNS INT
AS
BEGIN

	IF @IdTipoComprobante = 189
	BEGIN
		SET @IdTipoComprobante = 4
	END	
	ELSE IF @IdTipoComprobante = 190
	BEGIN
		SET @IdTipoComprobante = 2
	END
	
	DECLARE @IdPlanCuenta INT = (SELECT IdPlanCuenta FROM ERP.TipoComprobantePlanCuenta
								WHERE IdEmpresa = @IdEmpresa AND IdTipoComprobante = @IdTipoComprobante
								AND IdTipoRelacion = @IdTipoRelacion AND IdMoneda = @IdMoneda AND IdSistema = @IdSistema AND IdAnio = @IdAnio)

	RETURN 	@IdPlanCuenta

END
