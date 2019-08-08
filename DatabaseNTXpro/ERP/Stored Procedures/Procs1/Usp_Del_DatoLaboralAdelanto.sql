
CREATE PROC [ERP].[Usp_Del_DatoLaboralAdelanto]
@IdAdelanto INT,
@IdDatoLaboral INT
AS
BEGIN
		DELETE ERP.DatoLaboralAdelanto WHERE ID = @IdAdelanto AND IdDatoLaboral = @IdDatoLaboral
END
