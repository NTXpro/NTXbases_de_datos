
CREATE PROC [ERP].[Usp_ObtenerIdAnioByAnio]
@Anio INT
AS
BEGIN		
	DECLARE @IdAnio INT = (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio);
	SELECT @IdAnio
END
