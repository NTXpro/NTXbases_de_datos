CREATE PROC [ERP].[Usp_Sel_DatoLaboralConceptoFijo_By_ID] 
@IdDatoLaboralConceptoFijo INT
AS
BEGIN
		SELECT	DLCF.ID,
				DLCF.IdDatoLaboral,
				DLCF.IdConcepto,
				DLCF.IdTipoConceptoFijo,
				DLCF.IdEmpresa,
				DLCF.IdPeriodoInicio,
				DLCF.IdPeriodoFin,
				DLCF.Monto,
				CO.ID ,
				CO.Nombre,
				TCF.ID,
				TCF.Nombre
		FROM [ERP].[DatoLaboralConceptoFijo] DLCF
		INNER JOIN ERP.Concepto CO ON CO.ID = DLCF.IdConcepto
		INNER JOIN Maestro.TipoConceptoFijo TCF ON TCF.ID = DLCF.IdTipoConceptoFijo
		INNER JOIN ERP.DatoLaboral DL ON DL.ID = DLCF.IdDatoLaboral
		INNER JOIN ERP.Empresa EM ON EM.ID = DLCF.IdEmpresa
		WHERE DLCF.ID = @IdDatoLaboralConceptoFijo
END
