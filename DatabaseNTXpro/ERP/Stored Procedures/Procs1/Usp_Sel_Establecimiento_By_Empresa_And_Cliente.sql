CREATE PROC [ERP].[Usp_Sel_Establecimiento_By_Empresa_And_Cliente]
@IdEmpresa INT,
@IdEntidad INT
AS
BEGIN
		DECLARE @IdEntidadEmpresa INT = (SELECT IdEntidad FROM ERP.Empresa WHERE ID = @IdEmpresa)

		SELECT E.ID,
			   CONCAT(E.Nombre,'-EMPRESA') Direccion,
			   U.ID IdUbigeo,
			   ISNULL(E.Direccion + '-EMPRESA','') Nombre,
			   ISNULL(E.Direccion + ISNULL(('  ' + U.Nombre + '  ' + (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID)) + '  ' + (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID))),'') + '-EMPRESA','') DireccionUbigeo
		FROM ERP.Establecimiento E
		--INNER JOIN ERP.Entidad ENT ON ENT.ID = ES.IdEntidad 
		--INNER JOIN ERP.Establecimiento E ON E.IdEntidad = ENT.ID
		INNER JOIN PLAME.T7Ubigeo U ON U.ID = E.IdUbigeo
		WHERE E.IdEntidad = @IdEntidadEmpresa AND E.Flag = 1 AND E.FlagBorrador = 0

		UNION ALL

		SELECT E.ID,
			   CONCAT(E.Nombre,'-ENTIDAD') Direccion,
			   U.ID IdUbigeo,
			   ISNULL(E.Direccion + '-ENTIDAD','') Nombre,
			   ISNULL(E.Direccion + ISNULL((' ' + U.Nombre + '  ' + (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID)) + '  ' + (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID))),'')+ '-ENTIDAD','') DireccionUbigeo
		FROM ERP.Establecimiento E
		--INNER JOIN ERP.Entidad ENT ON ENT.ID = ES.IdEntidad
		--INNER JOIN ERP.Establecimiento E ON E.IdEntidad = ENT.ID
		INNER JOIN PLAME.T7Ubigeo U ON U.ID = E.IdUbigeo
		WHERE E.IdEntidad = @IdEntidad AND E.Flag = 1 AND E.FlagBorrador = 0

END