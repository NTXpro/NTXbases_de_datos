
create FUNCTION [ERP].[ObtenerAsignacionFamiliarDatoLaboralByFecha](
@IdDatoLaboral INT,
@Fecha DATETIME
)
RETURNS DECIMAL(14,5)
AS
BEGIN
		DECLARE @AsignacionFamiliar DECIMAL(14,5) = 0;
		DECLARE @IdEmpresa INT= (SELECT IdEmpresa FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral)
		DECLARE @FlagAsignacionFamiliar BIT= (SELECT FlagAsignacionFamiliar FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral)
		DECLARE @FechaAsignacionFamiliar DATETIME= (SELECT FechaInicioAsignacionFamiliar FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral)

		IF @FlagAsignacionFamiliar = 1 AND @FechaAsignacionFamiliar IS NOT NULL AND  CAST(@FechaAsignacionFamiliar AS DATE) <= CAST(@Fecha AS DATE)
		BEGIN
			DECLARE @SueldoMinimo DECIMAL(14,5)= (SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa,'RRHHSM',GETDATE()));
			DECLARE @PorcentajeAFamiliar DECIMAL(14,5)= (SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa,'RRHHPAS',GETDATE()));

			SET @AsignacionFamiliar = @SueldoMinimo * (@PorcentajeAFamiliar / 100);
		END

		RETURN @AsignacionFamiliar;
END
