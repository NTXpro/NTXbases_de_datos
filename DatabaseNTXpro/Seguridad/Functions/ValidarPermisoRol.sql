

CREATE FUNCTION [Seguridad].[ValidarPermisoRol](
@IdUsuario INT,
@IdPagina INT)
RETURNS INT
AS
BEGIN

	DECLARE @PaginasGenerales TABLE (ID INT);
	INSERT @PaginasGenerales(ID) VALUES(2),(152);    --PAGINAS QUE SON VISUALIZADAS POR TODOS LOS USUARIOS
	DECLARE @RolPagina INT;

	IF (EXISTS(SELECT * FROM @PaginasGenerales WHERE ID = @IdPagina))
		BEGIN
			SET @RolPagina = CAST(1 AS INT); 
		END
	ELSE
		BEGIN
		SET @RolPagina  =(SELECT 
									COUNT(PR.ID) 
							FROM Seguridad.UsuarioRol UR INNER JOIN Seguridad.Rol R
								ON R.ID = UR.IdRol
							INNER JOIN Seguridad.PaginaRol PR
								ON PR.IdRol = R.ID
							WHERE UR.IdUsuario = @IdUsuario AND PR.IdPagina = @IdPagina AND PR.Ver = 1)

			SET @RolPagina = ISNULL(@RolPagina,0);
		END

		RETURN @RolPagina;
END


