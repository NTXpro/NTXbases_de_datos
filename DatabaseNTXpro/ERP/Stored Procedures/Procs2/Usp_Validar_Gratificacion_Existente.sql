CREATE PROC ERP.Usp_Validar_Gratificacion_Existente
@IdEmpresa INT,
@IdAnio INT,
@IdFecha INT
AS
BEGIN
	DECLARE @IdGratificacion INT = (SELECT ID FROM ERP.Gratificacion 
									WHERE IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio AND IdFecha = @IdFecha)

	SELECT ISNULL(@IdGratificacion, 0)
END
