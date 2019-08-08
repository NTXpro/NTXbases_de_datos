CREATE PROC [ERP].[Usp_Ins_DatoLaboralConceptoFijo]
@IdDatoLaboralConceptoFijo INT OUT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@IdConcepto INT,
@IdTipoConceptoFijo INT,
@IdPeriodoInicio INT,
@IdPeriodoFin INT,
@Monto DECIMAL(14,5)
AS
BEGIN

	INSERT INTO ERP.DatoLaboralConceptoFijo(
		IdDatoLaboral,
		IdEmpresa,
		IdConcepto,
		IdTipoConceptoFijo,
		IdPeriodoInicio,
		IdPeriodoFin,
		Monto)
	VALUES( @IdDatoLaboral,
			@IdEmpresa,
			@IdConcepto,
			@IdTipoConceptoFijo,
			@IdPeriodoInicio,
			IIF(@IdPeriodoFin = 0, NULL, @IdPeriodoFin),
			@Monto)
	SET @IdDatoLaboralConceptoFijo = SCOPE_IDENTITY();

	SELECT @IdDatoLaboralConceptoFijo

END
