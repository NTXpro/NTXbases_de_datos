CREATE PROCEDURE [ERP].[Usp_Sel_ConceptoAFP_All_Detalle] --1,1,8,1
@IdEmpresa INT,
@IdConcepto INT,
@IdAnio INT,
@IdRegimenLaboral INT
AS
BEGIN
	SELECT
		CA.ID,
		CA.IdConcepto,
		CA.IdAnio,
		CA.IdRegimenLaboral,
		CAM.ID AS IdConceptoAFPMes,
		CAM.IdMes,
		CAMD.ID AS IdConceptoAFPMesDetalle,
		CAMD.IdConcepto AS IdConceptoDetalle
	FROM [ERP].[ConceptoAFP] CA
	INNER JOIN [ERP].[Concepto] CC ON CA.IdConcepto = CC.ID
	INNER JOIN [ERP].[ConceptoAFPMes] CAM ON CA.ID = CAM.IdConceptoAFP
	LEFT JOIN [ERP].[ConceptoAFPMesDetalle] CAMD ON CAM.ID = CAMD.IdConceptoAFPMes
	LEFT JOIN [ERP].[Concepto] C ON CAMD.IdConcepto = C.ID
	WHERE
	CC.IdEmpresa = @IdEmpresa AND
	CA.IdConcepto = @IdConcepto AND
	CA.IdAnio = @IdAnio AND
	CA.IdRegimenLaboral = @IdRegimenLaboral
END
