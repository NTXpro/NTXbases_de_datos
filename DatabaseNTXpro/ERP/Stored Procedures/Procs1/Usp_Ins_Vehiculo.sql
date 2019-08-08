CREATE PROC [ERP].[Usp_Ins_Vehiculo]
@IdVehiculo INT OUT,
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
@UsuarioRegistro VARCHAR(250)
AS
BEGIN

	INSERT INTO ERP.Vehiculo(	
							  IdChofer,
							  IdEmpresaTransporte,
							  IdTipoDocumento,
							  Color,
							  Marca,
							  Placa,
							  Modelo,
							  Inscripcion,
							  Flag,
							  FlagBorrador,
							  UsuarioRegistro,
							  FechaRegistro
							)VALUES
									(
										@IdChofer,
										@IdEmpresaTransporte,
										@IdTipoDocumento,
										@Color,
										@Marca,
										@Placa,
										@Modelo,
										@Inscripcion,
										@Flag,
										@FlagBorrador,
										@UsuarioRegistro,
										DATEADD(HOUR, 3, GETDATE())
									)
						SET @IdVehiculo = SCOPE_IDENTITY();

END