CREATE PROCEDURE [ERP].[Usp_Sel_ConceptoPorcentaje_All_Detalle] --1,1,8,1
@IdEmpresa INT,
@IdConcepto INT,
@IdAnio INT,
@IdRegimenLaboral INT
AS
BEGIN
	SELECT
		CP.ID,
		CP.IdConcepto,
		CP.IdAnio,
		CP.IdRegimenLaboral,
		CPM.ID AS IdConceptoPorcentajeMes,
		CPM.IdMes,
		CPM.Porcentaje,
		CPMD.ID AS IdConceptoPorcentajeMesDetalle,
		CPMD.IdConcepto AS IdConceptoDetalle
	FROM [ERP].[ConceptoPorcentaje] CP
	INNER JOIN [ERP].[Concepto] CC ON CP.IdConcepto = CC.ID
	INNER JOIN [ERP].[ConceptoPorcentajeMes] CPM ON CP.ID = CPM.IdConceptoPorcentaje
	INNER JOIN [ERP].[ConceptoPorcentajeMesDetalle] CPMD ON CPM.ID = CPMD.IdConceptoPorcentajeMes
	INNER JOIN [ERP].[Concepto] C ON CPMD.IdConcepto = C.ID
	WHERE
	CC.IdEmpresa = @IdEmpresa AND
	CP.IdConcepto = @IdConcepto AND
	CP.IdAnio = @IdAnio AND
	CP.IdRegimenLaboral = @IdRegimenLaboral
END
