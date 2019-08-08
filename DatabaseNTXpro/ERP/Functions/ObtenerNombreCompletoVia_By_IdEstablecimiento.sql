

CREATE FUNCTION [ERP].[ObtenerNombreCompletoVia_By_IdEstablecimiento](
@IdEstablecimiento INT
)
RETURNS VARCHAR(250)
AS
BEGIN
	DECLARE @NombreVia VARCHAR(250) = (SELECT ISNULL(V.Nombre,'') + ' '  + ISNULL(E.ViaNombre,'') + ' ' + ISNULL(E.ViaNumero,'')
										FROM ERP.Establecimiento E 
										INNER JOIN PLAME.T5Via V
											ON V.ID = E.IdVia
										WHERE E.ID = @IdEstablecimiento)

	RETURN ISNULL(@NombreVia,'')
END




