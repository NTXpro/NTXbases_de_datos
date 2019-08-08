
create FUNCTION [Seguridad].[ValidarCheckSistemaModulo](
@IdRol INT,
@IdSistema INT,
@IdModulo INT
)
RETURNS INT
AS
BEGIN
	DECLARE @Count INT;

	SET @Count = (SELECT COUNT(PR.ID) 
					FROM Seguridad.PaginaRol PR 
					INNER JOIN Seguridad.Pagina P 
					ON P.ID = PR.IdPagina 
					INNER JOIN Seguridad.Modulo M
					ON M.ID = P.IdModulo
					WHERE PR.IdRol = @IdRol AND (P.IdModulo = @IdModulo OR M.IdSistema = @IdSistema) AND PR.Ver = 1)
					 
	RETURN ISNULL(@Count,0)
END


