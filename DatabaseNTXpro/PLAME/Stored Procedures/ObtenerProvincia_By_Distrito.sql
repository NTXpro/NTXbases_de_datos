CREATE PROC PLAME.ObtenerProvincia_By_Distrito
@IdDistrito INT
AS
BEGIN
		
		DECLARE @IdProvincia INT = (SELECT [PLAME].[ObtenerIdProvincia_By_Distrito](@IdDistrito))	
		
		SELECT @IdProvincia

END
