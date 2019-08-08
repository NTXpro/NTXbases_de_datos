CREATE PROC [ERP].[Usp_Upd_Vehiculo]
@IdVehiculo INT,
@IdChofer INT,
@IdEmpresaTransporte INT,
@IdTipoDocumento INT,
@Color VARCHAR(250),
@Marca VARCHAR(250),
@Placa VARCHAR(250),
@Modelo VARCHAR(250),
@Inscripcion VARCHAR(250),
@Flag BIT,
@FlagBorrador BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN

	UPDATE ERP.Vehiculo		SET
							  IdChofer = @IdChofer,
							  IdEmpresaTransporte = @IdEmpresaTransporte,
							  IdTipoDocumento = @IdTipoDocumento,
							  Color = @Color,
							  Marca = @Marca,
							  Placa = @Placa,
							  Modelo = @Modelo,
							  Inscripcion = @Inscripcion,
							  Flag = @Flag,
							  FlagBorrador = @FlagBorrador,
							  UsuarioModifico = @UsuarioModifico,
							  FechaModificado = DATEADD(HOUR, 3, GETDATE())
							 WHERE ID = @IdVehiculo
END