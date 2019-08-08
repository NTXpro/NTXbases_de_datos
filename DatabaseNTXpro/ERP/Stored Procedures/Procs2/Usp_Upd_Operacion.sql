
CREATE PROC ERP.Usp_Upd_Operacion
@IdOperacion INT,
@IdEmpresa INT ,
@IdAnio INT,
@IdTipoMovimiento INT,
@IdPlanCuenta INT,
@Nombre VARCHAR(250),
@Descripcion VARCHAR(250),
@Flag BIT,
@FlagBorrador BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN

		UPDATE ERP.Operacion  SET IdEmpresa =@IdEmpresa,
								  IdAnio = @IdAnio,
								  IdTipoMovimiento = @IdTipoMovimiento,
								  IdPlanCuenta = @IdPlanCuenta,
								  Nombre = @Nombre,
								  Descripcion = @Descripcion,
								  Flag = @Flag,
								  FlagBorrador = @FlagBorrador,
								  UsuarioModifico = @UsuarioModifico,
								  FechaModificado = DATEADD(HOUR, 3, GETDATE())
								  WHERE ID = @IdOperacion
END
