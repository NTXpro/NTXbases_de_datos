

CREATE PROC [ERP].[Usp_Del_DatoLaboralSuspension]
@IdSuspension INT,
@IdDatoLaboral INT
AS
BEGIN
		DELETE ERP.DatoLaboralSuspension WHERE ID = @IdSuspension AND IdDatoLaboral = @IdDatoLaboral
END
