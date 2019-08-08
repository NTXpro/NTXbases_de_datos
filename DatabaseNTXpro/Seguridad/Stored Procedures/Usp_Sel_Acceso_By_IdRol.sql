
CREATE PROC [Seguridad].[Usp_Sel_Acceso_By_IdRol] --4184
@IdRol INT
AS
BEGIN

DECLARE @Sistema VARCHAR(4)= (SELECT Valor FROM ERP.Parametro WHERE Abreviatura = 'SIS')
DECLARE @ListaTreeView AS TABLE(Id INT,Nombre VARCHAR(250),IdPadre INT,Nivel INT,NivelPagina INT,IdPaginaPadre INT,[Check] BIT);

IF	@Sistema = 'FE'
BEGIN
	INSERT INTO @ListaTreeView 

	SELECT 1 , @Sistema, CAST(0 AS INT) IdPadre, CAST(2 AS INT) AS Nivel, NULL NivelPagina, NULL IdPaginaPadre, 
	CASE WHEN (SELECT COUNT(ID) FROM Seguridad.PaginaRol WHERE IdRol = @IdRol AND Ver = 1) > 0 THEN 1 ELSE 0 END Checked 

	UNION

	SELECT DISTINCT S.ID, S.Nombre, CAST(1 AS INT) IdPadre, CAST(3 AS INT) AS Nivel, NULL NivelPagina, NULL IdPaginaPadre,
	(CASE WHEN (SELECT [Seguridad].[ValidarCheckSistemaModulo](@IdRol,S.ID,0)) > 0 THEN 1 ELSE 0 END) Checked
	FROM Seguridad.Sistema S
	LEFT JOIN Seguridad.Modulo M ON M.IdSistema = S.ID
	LEFT JOIN Seguridad.Pagina P ON P.IdModulo = M.ID
	WHERE S.ID IN (1,2)

	UNION ALL

	SELECT DISTINCT  M.ID, M.Nombre, M.IdSistema IdPadre,CAST(4 AS INT) AS Nivel, M.Orden NivelPagina,NULL IdPaginaPadre,
	(CASE WHEN (SELECT [Seguridad].[ValidarCheckSistemaModulo](@IdRol,0,M.ID)) > 0 THEN 1 ELSE 0 END) Checked
	FROM Seguridad.Modulo M
	WHERE M.ID NOT IN (1,7,54,1064,5)

	UNION ALL

	SELECT DISTINCT P.ID,P.Nombre, P.IdModulo IdPadre, CAST(5 AS INT) AS Nivel,P.Orden NivelPagina,IdPaginaPadre IdPaginaPadre,
	PR.Ver Checked
	FROM Seguridad.Pagina P 
	LEFT JOIN Seguridad.PaginaRol PR ON PR.IdPagina = P.ID AND PR.IdRol = @IdRol
	WHERE P.IdPaginaPadre IS NOT NULL AND P.IdPaginaPadre IN (1,17) AND P.ID NOT IN (152,3,5,10,154) AND P.IdModulo NOT IN (7,54)
END
ELSE --ERP
BEGIN
	INSERT INTO @ListaTreeView 

	SELECT 1 , @Sistema, CAST(0 AS INT) IdPadre, CAST(2 AS INT) AS Nivel, NULL NivelPagina, NULL IdPaginaPadre,
	CASE WHEN (SELECT COUNT(ID) FROM Seguridad.PaginaRol WHERE IdRol = @IdRol AND Ver = 1) > 0 THEN 1 ELSE 0 END Checked 

	UNION

	SELECT DISTINCT S.ID, S.Nombre, CAST(1 AS INT) IdPadre, CAST(3 AS INT) AS Nivel, NULL NivelPagina, NULL IdPaginaPadre,
	(CASE WHEN (SELECT [Seguridad].[ValidarCheckSistemaModulo](@IdRol,S.ID,0)) > 0 THEN 1 ELSE 0 END) Checked
	FROM Seguridad.Sistema S
	LEFT JOIN Seguridad.Modulo M ON M.IdSistema = S.ID
	LEFT JOIN Seguridad.Pagina P ON P.IdModulo = M.ID

	UNION ALL

	SELECT DISTINCT  M.ID, M.Nombre, M.IdSistema IdPadre,CAST(4 AS INT) AS Nivel, M.Orden NivelPagina,NULL IdPaginaPadre,
	(CASE WHEN (SELECT [Seguridad].[ValidarCheckSistemaModulo](@IdRol,0,M.ID)) > 0 THEN 1 ELSE 0 END) Checked
	FROM Seguridad.Modulo M
	WHERE M.ID NOT IN (1)

	UNION ALL

	SELECT DISTINCT P.ID,P.Nombre, P.IdModulo IdPadre, CAST(5 AS INT) AS Nivel,P.Orden NivelPagina,IdPaginaPadre IdPaginaPadre,
	PR.Ver Checked
	FROM Seguridad.Pagina P 
	LEFT JOIN Seguridad.PaginaRol PR ON PR.IdPagina = P.ID AND PR.IdRol = @IdRol
	WHERE P.IdPaginaPadre IS NOT NULL AND P.IdModulo NOT IN (61)
END

	SELECT DISTINCT	Id,
					Nombre,
					IdPadre,
					Nivel,
					NivelPagina,
					IdPaginaPadre,
					[Check]
	FROM @ListaTreeView LTV

END
