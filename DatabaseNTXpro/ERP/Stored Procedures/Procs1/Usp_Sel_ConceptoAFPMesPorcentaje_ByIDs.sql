CREATE PROC [ERP].[Usp_Sel_ConceptoAFPMesPorcentaje_ByIDs] --48, 8, 1
@IdConcepto INT,
@IdAnio INT,
@IdRegimenLaboral INT
AS
BEGIN
	SELECT 
		A.ID AS IdAFP,
	    A.IdEntidad,
		A.Codigo,
		A.FlagTope,
		CAMP.ID,
		CAMP.IdConceptoAFPMes,
		CAMP.Porcentaje,
		CAM.IdMes
	FROM [ERP].[ConceptoAFPMesPorcentaje] CAMP
	INNER JOIN [ERP].[ConceptoAFPMes] CAM ON CAMP.IdConceptoAFPMes = CAM.ID
	INNER JOIN [ERP].[ConceptoAFP] CA ON CAM.IdConceptoAFP = CA.ID
	INNER JOIN [ERP].[AFP] A ON CAMP.IdAFP = A.ID
    WHERE
	A.Flag = 1 AND
	CA.IdConcepto = @IdConcepto AND
	CA.IdAnio = @IdAnio AND
	CA.IdRegimenLaboral = @IdRegimenLaboral
END
