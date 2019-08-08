
CREATE PROC [ERP].[Usp_Upd_Vehiculo_Activar]
@IdVehiculo INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN

	UPDATE ERP.Vehiculo		SET
							  UsuarioActivo = @UsuarioActivo,
							  FechaActivacion = DATEADD(HOUR, 3, GETDATE()),
							  Flag = 1
							 WHERE ID = @IdVehiculo
END
