CREATE PROC ERP.Usp_ValidarProyecto_By_TipoComprobante 
@IdProveedor INT,
@IdTipoComprobante INT,
@IdMoneda INT,
@IdAnio INT,
@IdEmpresa INT
AS
BEGIN

			DECLARE @IdTipoRelacion INT = (SELECT IdTipoRelacion FROM ERP.Proveedor WHERE ID = @IdProveedor)
			DECLARE @IdSistema INT = 4 /*COMPRAS*/

			DECLARE @Anio INT = (SELECT ID FROM Maestro.Anio WHERE Nombre = CAST(@IdAnio AS VARCHAR(4)))

			DECLARE @IdPlanCuenta INT = (SELECT ERP.ObtenerPlanCuentaByTipoComprobantePlanCuenta (@IdEmpresa,@IdTipoComprobante,@IdTipoRelacion,@IdMoneda,@IdSistema,@Anio))

			IF(@IdPlanCuenta IS NULL)
				BEGIN

					SELECT CAST(0 AS BIT)

				END
			ELSE
				BEGIN
					SELECT CAST(1 AS BIT)
				END
END
