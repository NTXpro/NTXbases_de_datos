
CREATE PROC [ERP].[Usp_Sel_Empresa_Usuario] --4184
@IdUsuario INT
AS
BEGIN


	DECLARE @ListaTreeView AS TABLE(Id INT,Nombre VARCHAR(250),IdPadre INT,Nivel INT,NivelPagina INT,IdPaginaPadre INT,[Check] BIT);
	
	INSERT INTO @ListaTreeView 

	SELECT 1 , 'EMPRESAS', CAST(0 AS INT) IdPadre, CAST(2 AS INT) AS Nivel, NULL NivelPagina, NULL IdPaginaPadre, 
	CASE WHEN (SELECT COUNT(ID) FROM ERP.EmpresaUsuario WHERE IdUsuario = @IdUsuario) > 0 THEN 1 ELSE 0 END Checked 

	UNION

	SELECT DISTINCT E.ID, EN.Nombre, CAST(1 AS INT) IdPadre, CAST(3 AS INT) AS Nivel, NULL NivelPagina, NULL IdPaginaPadre,
	(CASE WHEN (SELECT COUNT(ID) FROM ERP.EmpresaUsuario WHERE IdEmpresa = E.ID AND IdUsuario = @IdUsuario) > 0 THEN 1 ELSE 0 END) Checked
	FROM ERP.Empresa E
	INNER JOIN ERP.Entidad EN ON EN.ID = E.IdEntidad
	WHERE E.Flag = 1 AND E.FlagBorrador = 0 AND E.FlagBorrador = 0 AND E.Flag = 1

	SELECT DISTINCT	Id,
					Nombre,
					IdPadre,
					Nivel,
					NivelPagina,
					IdPaginaPadre,
					[Check]
	FROM @ListaTreeView LTV

END
