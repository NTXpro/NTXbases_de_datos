CREATE FUNCTION [PLAME].[ObtenerIdProvincia_By_Distrito](
@IdDistrito INT
)
RETURNS INT
AS
BEGIN

DECLARE @CodigoSunatDistrito VARCHAR(6)= (SELECT CodigoSunat FROM [PLAME].[T7Ubigeo] WHERE ID = @IdDistrito)

DECLARE @IdProvincia INT =(SELECT 
									U.ID
								FROM [PLAME].[T7Ubigeo] U
								WHERE U.CodigoSunat =  (SELECT CONCAT('00', SUBSTRING(@CodigoSunatDistrito,1,4))))

RETURN @IdProvincia
END
