CREATE PROC ERP.Usp_Sel_UltimaFechaVacacion_By_DatoLaboral
@IdDatoLaboral INT
AS
BEGIN
	DECLARE @FechaFinVacacion DATETIME = (SELECT TOP 1 MAX(FechaFin) FROM ERP.Vacacion WHERE IdDatoLaboral = @IdDatoLaboral);

	SELECT @FechaFinVacacion;
END
