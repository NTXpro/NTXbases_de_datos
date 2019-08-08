

CREATE FUNCTION [ERP].[ObtenerNombreCompletoZona_By_IdEstablecimiento](
@IdEstablecimiento INT
)
RETURNS VARCHAR(250)
AS
BEGIN
	DECLARE @NombreZona VARCHAR(250) = (SELECT ISNULL(T.Nombre,'') + ' '  + ISNULL(E.ZonaNombre,'')
										FROM ERP.Establecimiento E 
										INNER JOIN PLAME.T6Zona T
											ON T.ID = E.IdVia
										WHERE E.ID = @IdEstablecimiento)

	RETURN ISNULL(@NombreZona,'')
END




