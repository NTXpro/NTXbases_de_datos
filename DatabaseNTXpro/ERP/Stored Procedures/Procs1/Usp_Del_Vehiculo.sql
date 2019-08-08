CREATE PROC ERP.Usp_Del_Vehiculo
@IdVehiculo INT
AS
BEGIN
			DELETE ERP.Vehiculo WHERE ID = @IdVehiculo
END
