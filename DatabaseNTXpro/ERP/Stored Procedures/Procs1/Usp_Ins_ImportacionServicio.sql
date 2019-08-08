CREATE PROC ERP.Usp_Ins_ImportacionServicio
@IdImporteServicio INT OUT,
@Nombre VARCHAR(250),
@Descripcion VARCHAR(250),
@Flag BIT,
@FlagBorrador BIT,
@UsuarioRegistro VARCHAR(250)
AS
BEGIN
			INSERT INTO Maestro.ImportacionServicio(Nombre,
													Descripcion,
													Flag,
													FlagBorrador,
													UsuarioRegistro,
													FechaRegistro
													)
													VALUES
													(
													@Nombre,
													@Descripcion,
													@Flag,
													@FlagBorrador,
													@UsuarioRegistro,
													DATEADD(HOUR, 3, GETDATE())
													)

						
						SET @IdImporteServicio = SCOPE_IDENTITY();

END
