CREATE PROC [ERP].[Usp_Sel_DatoLaboralConceptoFijo] 
@IdDatoLaboral INT,
@IdEmpresa INT
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
				CO.Nombre AS Concepto,
				TCF.Nombre AS TipoConceptoFijo,
				AI.Nombre AS AnioInicio,
				MI.Nombre AS MesInicio,
				AF.Nombre AS AnioFin,
				MF.Nombre AS MesFin
		FROM ERP.DatoLaboralConceptoFijo DLCF
		INNER JOIN ERP.Periodo PEI ON PEI.ID = DLCF.IdPeriodoInicio
		INNER JOIN Maestro.Anio AI ON AI.ID = PEI.IdAnio
		INNER JOIN Maestro.Mes MI ON MI.ID = PEI.IdMes
		LEFT JOIN ERP.Periodo PEF ON PEF.ID = DLCF.IdPeriodoFin
		LEFT JOIN Maestro.Anio AF ON AF.ID = PEF.IdAnio
		LEFT JOIN Maestro.Mes MF ON MF.ID = PEF.IdMes
		INNER JOIN ERP.Concepto CO ON CO.ID = DLCF.IdConcepto
		INNER JOIN Maestro.TipoConceptoFijo TCF ON TCF.ID = DLCF.IdTipoConceptoFijo
		INNER JOIN ERP.DatoLaboral DL ON DL.ID = DLCF.IdDatoLaboral
		INNER JOIN ERP.Empresa EM ON EM.ID = DLCF.IdEmpresa
		WHERE DLCF.IdDatoLaboral = @IdDatoLaboral AND EM.ID = @IdEmpresa
END
