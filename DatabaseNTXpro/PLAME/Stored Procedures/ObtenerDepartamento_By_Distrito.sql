CREATE PROC PLAME.ObtenerDepartamento_By_Distrito
@IdDistrito INT
AS
BEGIN
		
		DECLARE @IdDepartamento INT = (SELECT [PLAME].[ObtenerIdDepartamento_By_Distrito](@IdDistrito))	
		
		SELECT @IdDepartamento

END
