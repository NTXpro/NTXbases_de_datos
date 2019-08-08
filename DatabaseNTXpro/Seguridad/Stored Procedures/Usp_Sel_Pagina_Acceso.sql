
CREATE PROC [Seguridad].[Usp_Sel_Pagina_Acceso]-- 2
@IdRol INT
AS
BEGIN
	DECLARE @Sistema VARCHAR(4)= (SELECT Valor FROM ERP.Parametro WHERE Abreviatura = 'SIS')

	IF	@Sistema = 'FE'
	BEGIN

		SELECT 
			P.ID															AS "IdPagina", 
			P.Nombre														AS "NombrePagina", 
			P.IdModulo														AS "IdModulo", 
			M.IdSistema														AS IdSistema, 
			(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Ver'))			AS "CheckVer",
			(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Nuevo'))		AS "CheckNuevo",
			(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Editar'))		AS "CheckEditar",
			(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Eliminar'))	AS "CheckEliminar",
			(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Restaurar'))	AS "CheckRestaurar"
		FROM Seguridad.Pagina P INNER JOIN Seguridad.Modulo M
			ON M.ID = P.IdModulo
		INNER JOIN Seguridad.Sistema S
			ON M.IdSistema = S.ID
		INNER JOIN Seguridad.TamanioPagina TP
			ON TP.ID = P.IdTamanioPagina
		WHERE P.IdPaginaPadre IN (1,17) AND P.ID NOT IN (152,3,5,10,154) AND P.IdModulo NOT IN (7,54)
		ORDER BY P.ORDEN
	END
	ELSE
	BEGIN
		SELECT 
				P.ID															AS "IdPagina", 
				P.Nombre														AS "NombrePagina", 
				P.IdModulo														AS "IdModulo", 
				M.IdSistema														AS IdSistema, 
				(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Ver'))			AS "CheckVer",
				(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Nuevo'))		AS "CheckNuevo",
				(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Editar'))		AS "CheckEditar",
				(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Eliminar'))	AS "CheckEliminar",
				(SELECT [Seguridad].[ValidarAcceso](@IdRol,P.ID,'Restaurar'))	AS "CheckRestaurar"
			FROM Seguridad.Pagina P INNER JOIN Seguridad.Modulo M
				ON M.ID = P.IdModulo
			INNER JOIN Seguridad.Sistema S
				ON M.IdSistema = S.ID
			INNER JOIN Seguridad.TamanioPagina TP
				ON TP.ID = P.IdTamanioPagina
			WHERE P.ID NOT IN (3) --AND P.IdModulo NOT IN (61)
			ORDER BY P.ORDEN
	END
END
