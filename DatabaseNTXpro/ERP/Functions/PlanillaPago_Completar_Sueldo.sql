
-- =============================================
-- Author:		OMAR RODRIGUEZ
-- ALTER date: <ALTER Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION ERP.PlanillaPago_Completar_Sueldo
(
	@FechaInicio DATETIME,
	@FechaFin DATETIME,
	@IdTrabajador INT,
	@IdPlanilla INT
)
RETURNS decimal(18,5)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar decimal(18,5) = 0

	SELECT @ResultVar = A.Sueldo from
	(SELECT dld2.IdRegimenLaboral, DL.FlagAsignacionFamiliar,dld2.Sueldo,TS.Hora,RP.FlagONP,RS.CodigoSunat,TPE.ID AS IdTipoPension,TSA.ID AS IdTipoSalud,AFP.ID AS IdAFP,P.IdTipoComision  FROM ERP.DatoLaboralDetalle dld2
	INNER JOIN ERP.DatoLaboral DL ON DLD2.IdDatoLaboral = DL.ID AND DL.IdTrabajador = @IdTrabajador
	INNER JOIN Maestro.TipoSueldo TS ON DLD2.IdTipoSueldo = TS.ID -- PARA HORA TIPO SUELDO / SIEMPRE OBLIGATORIO
	LEFT JOIN ERP.TrabajadorPension P ON P.IdTrabajador = @IdTrabajador
	AND
	((@FechaInicio BETWEEN P.FechaInicio AND P.FechaFin) OR
	(@FechaFin BETWEEN P.FechaInicio AND P.FechaFin) OR
	 (P.FechaInicio < @FechaInicio OR P.FechaFin IS NULL))
	LEFT JOIN [PLAME].[T11RegimenPensionario] RP ON P.IdRegimenPensionario = RP.ID
	LEFT JOIN [ERP].[AFP] AFP ON RP.CodigoSunat = AFP.Codigo
	LEFT JOIN ERP.DatoLaboralSalud S ON DL.ID = S.IdDatoLaboral 
	AND
		((@FechaInicio BETWEEN S.FechaInicio AND S.FechaFin) OR
		 (@FechaFin BETWEEN S.FechaInicio AND S.FechaFin) OR
		 (S.FechaInicio < @FechaInicio OR S.FechaFin IS NULL))
	LEFT JOIN [PLAME].[T32RegimenSalud] RS ON S.IdRegimenSalud = RS.ID
	LEFT JOIN [ERP].[SCTR] SCTR ON DL.ID = SCTR.IdDatoLaboral 
	AND
		((@FechaInicio BETWEEN SCTR.FechaInicio AND SCTR.FechaFin) OR
		 (@FechaFin BETWEEN SCTR.FechaInicio AND SCTR.FechaFin))
	LEFT JOIN [Maestro].[TipoPension] TPE ON SCTR.IdTipoPension = TPE.ID
	LEFT JOIN [Maestro].[TipoSalud] TSA ON SCTR.IdTipoSalud = TSA.ID
	
	WHERE DLD2.IdPlanilla = @IdPlanilla	 AND
		((DLD2.FechaInicio BETWEEN @FechaInicio AND @FechaFin) OR
		 (DLD2.FechaFin BETWEEN @FechaInicio AND @FechaFin) OR
		 (DLD2.FechaInicio < @FechaInicio OR DLD2.FechaFin IS NULL))) A

	-- Return the result of the function
	RETURN @ResultVar

END