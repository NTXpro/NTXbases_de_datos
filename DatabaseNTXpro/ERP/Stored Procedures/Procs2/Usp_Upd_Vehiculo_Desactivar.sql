
CREATE PROC [ERP].[Usp_Upd_Vehiculo_Desactivar]
@IdVehiculo INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN

	UPDATE ERP.Vehiculo		SET
							  UsuarioElimino = @UsuarioElimino,
							  FechaEliminado = DATEADD(HOUR, 3, GETDATE()),
							  Flag = 0 
							 WHERE ID = @IdVehiculo
END
