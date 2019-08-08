

CREATE FUNCTION [PLAME].[ObtenerNombreProvincia_By_Distrito](
@IdDistrito INT
)
RETURNS VARCHAR(50)
AS
BEGIN

DECLARE @CodigoSunatDistrito VARCHAR(6)= (SELECT CodigoSunat FROM [PLAME].[T7Ubigeo] WHERE ID = @IdDistrito)

DECLARE @NombreProvincia VARCHAR(50) =(SELECT 
												U.Nombre
											FROM [PLAME].[T7Ubigeo] U
											WHERE U.CodigoSunat =  (SELECT CONCAT('00', SUBSTRING(@CodigoSunatDistrito,1,4))))

RETURN @NombreProvincia
END




