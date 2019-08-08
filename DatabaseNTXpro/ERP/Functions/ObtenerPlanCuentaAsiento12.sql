CREATE FUNCTION [ERP].[ObtenerPlanCuentaAsiento12](
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
	
	DECLARE @IdPlanCuenta INT = (SELECT IdPlanCuenta FROM ERP.TipoComprobantePlanCuenta
								WHERE IdEmpresa = @IdEmpresa AND IdTipoComprobante = @IdTipoComprobante
								AND IdTipoRelacion = @IdTipoRelacion AND IdMoneda = @IdMoneda AND IdSistema = @IdSistema AND IdAnio = @IdAnio)

	RETURN 	@IdPlanCuenta

END
