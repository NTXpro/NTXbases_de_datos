
CREATE FUNCTION [Seguridad].[ValidarPermisoLicencia](
@IdVersion INT,
@IdPagina INT)
RETURNS INT
AS
BEGIN

	DECLARE @PaginasGenerales TABLE (ID INT);
	INSERT @PaginasGenerales(ID) VALUES(2),(152);    --PAGINAS QUE SON VISUALIZADAS POR TODOS LOS USUARIOS
	DECLARE @LicenciaPagina INT;

	IF (EXISTS(SELECT * FROM @PaginasGenerales WHERE ID = @IdPagina))
		BEGIN
			SET @LicenciaPagina = CAST(1 AS INT); 
		END
	ELSE
		BEGIN
			SET @LicenciaPagina =(SELECT COUNT(VP.ID) FROM Seguridad.VersionPagina VP 
									WHERE IdVersion = @IdVersion AND IdPagina = @IdPagina AND FLAG = 1)

			SET @LicenciaPagina = ISNULL(@LicenciaPagina,0);
		END


	RETURN ISNULL(@LicenciaPagina,0);	
END


