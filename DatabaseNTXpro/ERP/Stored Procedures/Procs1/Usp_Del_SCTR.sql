CREATE PROC ERP.Usp_Del_SCTR
@IdSctr INT,
@IdDatoLaboral INT
AS
BEGIN
		DELETE ERP.SCTR WHERE ID = @IdSctr AND IdDatoLaboral = @IdDatoLaboral
END
