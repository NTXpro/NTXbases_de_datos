CREATE PROC [ERP].[Usp_Del_DatoLaboralConceptoFijo]
@IdDatoLaboralConceptoFijo INT,
@IdDatoLaboral INT
AS
BEGIN
		DELETE ERP.DatoLaboralConceptoFijo WHERE ID = @IdDatoLaboralConceptoFijo AND IdDatoLaboral = @IdDatoLaboral
END
