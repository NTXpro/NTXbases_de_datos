
CREATE FUNCTION [ERP].[ObtenerTotalDiasVacacionByIdDatoLaboral](
@IdDatoLaboral INT
)
RETURNS INT
AS
BEGIN
	DECLARE @TotalVacacion INT = (SELECT SUM(Dias) FROM ERP.Vacacion WHERE IdDatoLaboral = @IdDatoLaboral)
	RETURN ISNULL(@TotalVacacion,0);
END
