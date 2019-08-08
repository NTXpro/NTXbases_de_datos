
CREATE PROC [ERP].[Usp_Del_DatoLaboralPrestamo]
@IdPrestamo INT,
@IdDatoLaboral INT
AS
BEGIN
		DELETE ERP.DatoLaboralPrestamo WHERE ID = @IdPrestamo AND IdDatoLaboral = @IdDatoLaboral
END
