CREATE FUNCTION [PLAME].[ObtenerIdDepartamento_By_Distrito](
@IdDistrito INT
)
RETURNS INT
AS
BEGIN

DECLARE @CodigoSunatDistrito VARCHAR(6)= (SELECT CodigoSunat FROM [PLAME].[T7Ubigeo] WHERE ID = @IdDistrito)

DECLARE @IdDepartamento INT =(SELECT 
									U.ID
								FROM [PLAME].[T7Ubigeo] U
								WHERE U.CodigoSunat =  (SELECT CONCAT('0000', SUBSTRING(@CodigoSunatDistrito,1,2))))

RETURN @IdDepartamento
END
