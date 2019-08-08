
CREATE FUNCTION [Seguridad].[ValidarAcceso](
@IdRol INT,
@IdPagina INT,
@AccesoAccion VARCHAR(10)
)
RETURNS BIT
AS
BEGIN
	DECLARE @AccesoPagina BIT = 0

	IF @AccesoAccion = 'Nuevo'
		BEGIN
			SET @AccesoPagina =(SELECT TOP 1 Nuevo FROM Seguridad.PaginaRol PR 
									WHERE PR.IdPagina = @IdPagina AND PR.IdRol = @IdRol)
		END
	ELSE IF @AccesoAccion = 'Editar'
		BEGIN
			SET @AccesoPagina =(SELECT TOP 1 Editar FROM Seguridad.PaginaRol PR 
									WHERE PR.IdPagina = @IdPagina AND PR.IdRol = @IdRol)
		END
	ELSE IF @AccesoAccion = 'Eliminar'
		BEGIN
			SET @AccesoPagina =(SELECT TOP 1 Eliminar FROM Seguridad.PaginaRol PR 
									WHERE PR.IdPagina = @IdPagina AND PR.IdRol = @IdRol)
		END
	ELSE IF @AccesoAccion = 'Restaurar'
		BEGIN
			SET @AccesoPagina =(SELECT TOP 1 Restaurar FROM Seguridad.PaginaRol PR 
									WHERE PR.IdPagina = @IdPagina AND PR.IdRol = @IdRol)
		END
	ELSE IF @AccesoAccion = 'Ver'
		BEGIN
			SET @AccesoPagina =(SELECT TOP 1 Ver FROM Seguridad.PaginaRol PR 
									WHERE PR.IdPagina = @IdPagina AND PR.IdRol = @IdRol)
		END

	RETURN ISNULL(@AccesoPagina,0)
END


