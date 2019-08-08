CREATE PROC [ERP].[Usp_Sel_PlanillaPago_ListaConceptoPorcentaje]
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
		TEMP.IdAnio,
		TEMP.IdMes,
		TEMP.IdEmpresa
	FROM [PLAME].[T33RegimenLaboral] RL
	LEFT JOIN (SELECT
					A.ID AS IdAnio,
					M.ID AS IdMes,
					C.IdEmpresa,
					CPMD.IdConcepto AS IdConceptoDetalle,
					CPM.Porcentaje,
					CP.IdRegimenLaboral,
					CP.IdConcepto
				FROM [ERP].[ConceptoPorcentaje] CP
				INNER JOIN [ERP].[ConceptoPorcentajeMes] CPM ON CP.ID = CPM.IdConceptoPorcentaje
				INNER JOIN [ERP].[ConceptoPorcentajeMesDetalle] CPMD ON CPM.ID = CPMD.IdConceptoPorcentajeMes
				INNER JOIN [ERP].[Concepto] C ON CP.IdConcepto = C.ID
				INNER JOIN [Maestro].[Anio] A ON CP.IdAnio = A.ID
				INNER JOIN [Maestro].[Mes] M ON CPM.IdMes = M.ID
				WHERE
				A.Nombre = @ValorAnio AND
				M.Valor = @ValorMes AND
				C.IdEmpresa = @IdEmpresa) AS TEMP ON RL.ID = TEMP.IdRegimenLaboral OR TEMP.IdRegimenLaboral = 1
	WHERE 
	RL.FlagSectorPrivado = 1 AND 
	RL.FlagSectorPublico = 1 AND RL.ID <> 1 AND TEMP.IdRegimenLaboral = 1)
	SELECT
		T.IdConcepto,
		T.IdRegimenLaboral,
		T.IdConceptoDetalle,
		CASE WHEN CPMD.IdConcepto IS NULL THEN T.Porcentaje ELSE CPM.Porcentaje END AS Porcentaje
	FROM T
	LEFT JOIN [ERP].[ConceptoPorcentaje] CP ON T.IdRegimenLaboral = CP.IdRegimenLaboral AND CP.IdAnio = T.IdAnio AND CP.IdConcepto = T.IdConcepto
	LEFT JOIN [ERP].[ConceptoPorcentajeMes] CPM ON CP.ID = CPM.IdConceptoPorcentaje AND CPM.IdMes = T.IdMes
	LEFT JOIN [ERP].[ConceptoPorcentajeMesDetalle] CPMD ON CPM.ID = CPMD.IdConceptoPorcentajeMes AND CPMD.IdConcepto = T.IdConceptoDetalle
	LEFT JOIN [ERP].[Concepto] C ON CP.IdConcepto = C.ID 

END
