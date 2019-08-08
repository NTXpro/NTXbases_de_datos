
CREATE FUNCTION [PLAME].[ObtenerIdZona_By_Abreviatura](
@Abreviatura VARCHAR(5)
)
RETURNS INT
AS
BEGIN

DECLARE @Id VARCHAR(6)= (SELECT ID FROM [PLAME].[T6Zona] WHERE Abreviatura = @Abreviatura)

RETURN ISNULL(@Id,0)
END
