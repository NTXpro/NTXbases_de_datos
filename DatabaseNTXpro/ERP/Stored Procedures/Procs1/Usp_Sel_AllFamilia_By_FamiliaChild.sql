
CREATE PROC ERP.Usp_Sel_AllFamilia_By_FamiliaChild
@IdProducto INT,
@IdEmpresa INT
AS
BEGIN

DECLARE @IdFamilia INT = (SELECT FP.IdFamilia FROM ERP.FamiliaProducto FP WHERE IdProducto = @IdProducto AND IdEmpresa = @IdEmpresa);
	
WITH Familia (ID,IdEmpresa,IdFamiliaPadre,Nombre)
AS
(
	SELECT FA.ID,
		   FA.IdEmpresa,
		   FA.IdFamiliaPadre,
		   FA.Nombre
	FROM ERP.Familia FA
	WHERE FA.ID = @IdFamilia

	UNION ALL

	SELECT FA.ID,
		   FA.IdEmpresa,
		   FA.IdFamiliaPadre,
		   FA.Nombre 
	FROM ERP.Familia FA
	JOIN Familia AS SFA
	ON FA.ID = SFA.IdFamiliaPadre
)

SELECT * FROM Familia ORDER BY ID ASC 

END
