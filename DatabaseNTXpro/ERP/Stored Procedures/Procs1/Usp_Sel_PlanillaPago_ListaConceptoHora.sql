CREATE PROC [ERP].[Usp_Sel_PlanillaPago_ListaConceptoHora]
@IdEmpresa INT,
@ValorAnio INT,
@ValorMes INT
AS
BEGIN

	SELECT
		CH.IdConcepto,
		CHMD.IdConcepto AS IdConceptoDetalle,
		CHM.Factor
	FROM [ERP].[ConceptoHora] CH
	INNER JOIN [ERP].[ConceptoHoraMes] CHM ON CH.ID = CHM.IdConceptoHora
	INNER JOIN [ERP].[ConceptoHoraMesDetalle] CHMD ON CHM.ID = CHMD.IdConceptoHoraMes
	INNER JOIN [ERP].[Concepto] C ON CH.IdConcepto = C.ID
	INNER JOIN [Maestro].[Anio] A ON CH.IdAnio = A.ID
	INNER JOIN [Maestro].[Mes] M ON CHM.IdMes = M.ID
	WHERE
	A.Nombre = @ValorAnio AND
	M.Valor = @ValorMes 
	

END
