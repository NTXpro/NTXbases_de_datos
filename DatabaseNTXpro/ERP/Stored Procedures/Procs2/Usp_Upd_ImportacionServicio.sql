
CREATE PROC ERP.Usp_Upd_ImportacionServicio
@IdImporteServicio INT,
@Nombre VARCHAR(250),
@Descripcion VARCHAR(250),
@Flag BIT,
@FlagBorrador BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN
			UPDATE Maestro.ImportacionServicio	SET	Nombre = @Nombre,
													Descripcion = @Descripcion,
													Flag = @Flag,
													FlagBorrador = @FlagBorrador,
													UsuarioModifico = @UsuarioModifico,
													FechaModificado = DATEADD(HOUR, 3, GETDATE())
													WHERE ID = @IdImporteServicio
END
