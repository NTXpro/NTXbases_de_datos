
CREATE PROCEDURE [ERP].[Usp_Sel_Familia_Kardex] --1
@IdEmpresa INT
AS
BEGIN
	SELECT 
		F1.ID,
		F1.Nombre,
		F2.ID AS IdPadre,
		F2.Nombre AS NombrePadre
	FROM ERP.Familia F1
	LEFT JOIN ERP.Familia F2 ON F1.IdFamiliaPadre = F2.ID
	WHERE F1.IdEmpresa = @IdEmpresa
END
