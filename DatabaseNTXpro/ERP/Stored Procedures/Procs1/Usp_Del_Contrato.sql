CREATE PROC [ERP].[Usp_Del_Contrato]
@IdContrato INT,
@IdDatoLaboral INT
AS
BEGIN
		DELETE ERP.Contrato WHERE ID = @IdContrato AND IdDatoLaboral = @IdDatoLaboral
END
