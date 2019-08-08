CREATE PROC [ERP].[Usp_Sel_PlanillaPago_RemuneracionTope] --1,2017,1
@IdEmpresa INT,
@ValorAnio INT,
@ValorMes INT
AS
BEGIN

	WITH T AS (
	SELECT
		RL.ID AS IdRegimenLaboral,
		TEMP.IdConcepto,
		TEMP.IdConceptoDetalle,
		TEMP.Porcentaje,
		TEMP.IdAFP,
		TEMP.IdAnio,
		TEMP.IdMes,
		TEMP.IdEmpresa
	FROM [PLAME].[T33RegimenLaboral] RL
	LEFT JOIN (SELECT
					A.ID AS IdAnio,
					M.ID AS IdMes,
					C.IdEmpresa,
					CAMD.IdConcepto AS IdConceptoDetalle,
					CAMP.Porcentaje,
					CA.IdRegimenLaboral,
					CA.IdConcepto,
					CAMP.IdAFP
				FROM [ERP].[ConceptoAFP] CA
				INNER JOIN [ERP].[ConceptoAFPMes] CAM ON CA.ID = CAM.IdConceptoAFP
				INNER JOIN [ERP].[ConceptoAFPMesPorcentaje] CAMP ON CAM.ID = CAMP.IdConceptoAFPMes
				INNER JOIN [ERP].[ConceptoAFPMesDetalle] CAMD ON CAM.ID = CAMD.IdConceptoAFPMes
				INNER JOIN [ERP].[AFP] AFP ON CAMP.IdAFP = AFP.ID
				INNER JOIN [ERP].[Concepto] C ON CA.IdConcepto = C.ID
				INNER JOIN [Maestro].[Anio] A ON CA.IdAnio = A.ID
				INNER JOIN [Maestro].[Mes] M ON CAM.IdMes = M.ID
				WHERE
				A.Nombre = @ValorAnio AND
				M.Valor = @ValorMes AND
				C.IdEmpresa = @IdEmpresa AND
				AFP.FlagTope = 1) AS TEMP ON RL.ID = TEMP.IdRegimenLaboral OR TEMP.IdRegimenLaboral = 1
	WHERE 
	RL.FlagSectorPrivado = 1 AND 
	RL.FlagSectorPublico = 1 AND RL.ID <> 1 AND TEMP.IdRegimenLaboral = 1)
	SELECT
		T.IdConcepto,
		T.IdRegimenLaboral,
		T.IdAFP,
		CASE WHEN CAMD.IdConcepto IS NULL THEN T.Porcentaje ELSE CAMP.Porcentaje END AS Porcentaje
	FROM T
	LEFT JOIN [ERP].[ConceptoAFP] CA ON T.IdRegimenLaboral = CA.IdRegimenLaboral AND CA.IdAnio = T.IdAnio AND CA.IdConcepto = T.IdConcepto
	LEFT JOIN [ERP].[ConceptoAFPMes] CAM ON CA.ID = CAM.IdConceptoAFP AND CAM.IdMes = T.IdMes
	LEFT JOIN [ERP].[ConceptoAFPMesPorcentaje] CAMP ON CAM.ID = CAMP.IdConceptoAFPMes
	LEFT JOIN [ERP].[ConceptoAFPMesDetalle] CAMD ON CAM.ID = CAMD.IdConceptoAFPMes AND CAMD.IdConcepto = T.IdConceptoDetalle
	LEFT JOIN [ERP].[Concepto] C ON CA.IdConcepto = C.ID AND C.IdEmpresa = T.IdEmpresa
	GROUP BY
		T.IdConcepto,
		T.IdRegimenLaboral,
		T.IdAFP,
		CASE WHEN CAMD.IdConcepto IS NULL THEN T.Porcentaje ELSE CAMP.Porcentaje END
END
