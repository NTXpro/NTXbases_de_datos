CREATE PROC ERP.Usp_Ins_Operacion
@IdOperacion INT OUT,
@IdEmpresa INT ,
@IdAnio INT,
@IdTipoMovimiento INT,
@IdPlanCuenta INT,
@Nombre VARCHAR(250),
@Descripcion VARCHAR(250),
@Flag BIT,
@FlagBorrador BIT,
@UsuarioRegistro VARCHAR(250)
AS
BEGIN

		INSERT INTO ERP.Operacion(IdEmpresa,
								  IdAnio,
								  IdTipoMovimiento,
								  IdPlanCuenta,
								  Nombre,
								  Descripcion,
								  Flag,
								  FlagBorrador,
								  UsuarioRegistro,
								  FechaRegistro
								  )
								  VALUES(
											@IdEmpresa,
											@IdAnio,
											@IdTipoMovimiento,
											@IdPlanCuenta,
											@Nombre,
											@Descripcion,
											@Flag,
											@FlagBorrador,
											@UsuarioRegistro,
											DATEADD(HOUR, 3, GETDATE())
										)
				SET @IdOperacion = SCOPE_IDENTITY();

END
