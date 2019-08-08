
CREATE PROCEDURE [ERP].[Usp_Sel_FamiliaNodo]
@IdEmpresa INT
AS
BEGIN
	SELECT 
		F1.ID,
		F1.Nombre,
		F2.ID,
		F2.Nombre
	FROM ERP.Familia F1
	LEFT JOIN ERP.Familia F2 ON F1.IdFamiliaPadre = F2.ID
	WHERE F1.IdEmpresa = @IdEmpresa
END
