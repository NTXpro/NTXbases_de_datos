
create FUNCTION [ERP].[ObtenerSueldoDatoLaboralByFecha](
@IdDatoLaboral INT,
@Fecha DATETIME
)
RETURNS DECIMAL(14,5)
AS
BEGIN
		DECLARE @Sueldo DECIMAL(15,2) = (SELECT TOP 1 Sueldo 
									 FROM ERP.DatoLaboralDetalle 
									 WHERE IdDatoLaboral = @IdDatoLaboral
									 AND CAST(FechaInicio AS DATE) <= CAST(@Fecha AS DATE)
									 ORDER BY FechaInicio DESC)
		RETURN ISNULL(@Sueldo, 0)
END
