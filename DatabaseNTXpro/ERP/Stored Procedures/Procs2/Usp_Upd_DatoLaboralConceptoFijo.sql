
CREATE PROC [ERP].[Usp_Upd_DatoLaboralConceptoFijo]
@IdDatoLaboralConceptoFijo INT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@IdConcepto INT,
@IdTipoConceptoFijo INT,
@IdPeriodoInicio INT,
@IdPeriodoFin INT,
@Monto DECIMAL(14,5)
AS
BEGIN

	UPDATE [ERP].[DatoLaboralConceptoFijo] SET
		IdConcepto = @IdConcepto,
		IdTipoConceptoFijo = @IdTipoConceptoFijo,
		IdPeriodoInicio = @IdPeriodoInicio,
		IdPeriodoFin = IIF(@IdPeriodoFin = 0, NULL, @IdPeriodoFin),
		Monto = @Monto
	WHERE 
	ID = @IdDatoLaboralConceptoFijo AND 
	IdDatoLaboral = @IdDatoLaboral AND 
	IdEmpresa = @IdEmpresa

END
