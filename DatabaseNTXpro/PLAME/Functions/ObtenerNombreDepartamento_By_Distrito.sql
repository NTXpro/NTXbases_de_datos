

CREATE FUNCTION [PLAME].[ObtenerNombreDepartamento_By_Distrito](
@IdDistrito INT
)
RETURNS VARCHAR(50)
AS
BEGIN

DECLARE @CodigoSunatDistrito VARCHAR(6)= (SELECT CodigoSunat FROM [PLAME].[T7Ubigeo] WHERE ID = @IdDistrito)

DECLARE @NombreDepartamento VARCHAR(50) =(SELECT 
												U.Nombre
											FROM [PLAME].[T7Ubigeo] U
											WHERE U.CodigoSunat =  (SELECT CONCAT('0000', SUBSTRING(@CodigoSunatDistrito,1,2))))

RETURN @NombreDepartamento
END




