CREATE PROC [ERP].[Usp_Sel_Establecimiento_By_Empresa] --1
@IdEmpresa INT
AS
BEGIN
	--SELECT 
	--	EST.ID,
	--	EST.IdEntidad,
	--	EST.Nombre + ' - ' +EST.Direccion Nombre
	--FROM ERP.Empresa E
	--INNER JOIN ERP.Entidad ENT
	--	ON ENT.ID = E.IdEntidad
	--INNER JOIN ERP.Establecimiento EST
	--	ON EST.IdEntidad = E.IdEntidad 
	--WHERE E.ID = @IdEmpresa AND EST.Flag = 1 AND EST.FlagBorrador = 0
	
	SELECT
		EST.ID,
		EST.IdEntidad,
		CONCAT(EST.Nombre, ' - ', EST.Direccion) AS Nombre
	FROM ERP.Establecimiento EST
	INNER JOIN ERP.Empresa E ON EST.IdEntidad = E.IdEntidad
	INNER JOIN ERP.Entidad ENT ON E.IdEntidad = ENT.ID
	WHERE E.ID = @IdEmpresa AND EST.Flag = 1 AND EST.FlagBorrador = 0
	
END
