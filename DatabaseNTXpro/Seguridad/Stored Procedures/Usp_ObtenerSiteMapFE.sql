
CREATE PROC [Seguridad].[Usp_ObtenerSiteMapFE] --1,1
@IdUsuario INT,
@IdAplicacion INT
AS
BEGIN

DECLARE @IdVersion INT = (SELECT IdVersion FROM Seguridad.Usuario WHERE ID = @IdUsuario);
DECLARE @IdRol INT = (SELECT IdRol FROM Seguridad.UsuarioRol WHERE IdUsuario = @IdUsuario);

WITH ListaPaginas AS(
	SELECT
		NULL				AS "NombreSistema", 
		NULL				AS "NombreModulo",
		NULL				AS "IconoModulo",
		P.ID				AS "IdPagina", 
		P.IdPaginaPadre		AS "IdPaginaPadre", 
		P.Nombre			AS "NombrePagina", 
		P.Icono				AS "IconoPagina",
		P.Url,
		P.Orden,
		0 OrdenModulo,
		NULL				AS IdTamanioPagina, 
		NULL				AS "NombreTamanio"
	FROM Seguridad.Pagina P 
	WHERE P.ID IN (1,17)

	UNION

	SELECT 
		S.Nombre			AS "NombreSistema", 
		M.Nombre			AS "NombreModulo",
		M.Icono				AS "IconoModulo",
		P.ID				AS "IdPagina", 
		P.IdPaginaPadre		AS "IdPaginaPadre", 
		P.Nombre			AS "NombrePagina", 
		P.Icono				AS "IconoPagina",
		CASE WHEN (SELECT Seguridad.ValidarPermisoLicencia(@IdVersion,P.ID)) = 0 THEN
			'Screen/Licencia'
		WHEN (SELECT Seguridad.ValidarPermisoRol(@IdUsuario,P.ID)) = 0 THEN
			'Screen/Permiso'
		ELSE 
			P.Url
		END					AS Url,
		P.Orden,
		M.Orden OrdenModulo,
		TP.ID				AS IdTamanioPagina, 
		TP.Nombre			AS "NombreTamanio"
	FROM Seguridad.Pagina P INNER JOIN Seguridad.Modulo M
		ON M.ID = P.IdModulo
	INNER JOIN Seguridad.Sistema S
		ON M.IdSistema = S.ID
	INNER JOIN Seguridad.TamanioPagina TP
		ON TP.ID = P.IdTamanioPagina
	INNER JOIN Seguridad.PaginaRol PR
		ON PR.IdPagina = P.ID 
	WHERE ((PR.IdRol = @IdRol AND P.IdPaginaPadre IN (1,17) AND PR.Ver = 1) OR P.ID IN (2)) AND P.IdModulo NOT IN (13,1068) AND P.ID NOT IN (152,3,5,10,154)
	)

	SELECT * FROM ListaPaginas ORDER BY OrdenModulo,Orden
END
