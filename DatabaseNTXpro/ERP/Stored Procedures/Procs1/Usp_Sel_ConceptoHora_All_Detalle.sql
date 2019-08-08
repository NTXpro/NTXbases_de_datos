CREATE PROCEDURE [ERP].[Usp_Sel_ConceptoHora_All_Detalle] --1,1,8
@IdEmpresa INT,
@IdConcepto INT,
@IdAnio INT
AS
BEGIN
	SELECT
		CH.ID,
		CH.IdConcepto,
		CH.IdAnio,
		CHM.ID AS IdConceptoHoraMes,
		CHM.IdMes,
		CHM.Factor,
		CHMD.ID AS IdConceptoHoraMesDetalle,
		CHMD.IdConcepto AS IdConceptoDetalle
	FROM [ERP].[ConceptoHora] CH
	INNER JOIN [ERP].[Concepto] CC ON CH.IdConcepto = CC.ID
	INNER JOIN [ERP].[ConceptoHoraMes] CHM ON CH.ID = CHM.IdConceptoHora
	INNER JOIN [ERP].[ConceptoHoraMesDetalle] CHMD ON CHM.ID = CHMD.IdConceptoHoraMes
	INNER JOIN [ERP].[Concepto] C ON CHMD.IdConcepto = C.ID
	WHERE
	
	CH.IdConcepto = @IdConcepto AND
	CH.IdAnio = @IdAnio
END
