
CREATE PROC ERP.Usp_Upd_TransformacionServicio
@IdTransformacionServicio INT,
@Nombre VARCHAR(250),
@Descripcion VARCHAR(250),
@Flag BIT,
@FlagBorrador BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN
			UPDATE Maestro.TransformacionServicio	SET	Nombre = @Nombre,
													Descripcion = @Descripcion,
													Flag = @Flag,
													FlagBorrador = @FlagBorrador,
													UsuarioModifico = @UsuarioModifico,
													FechaModificado = DATEADD(HOUR, 3, GETDATE())
													WHERE ID = @IdTransformacionServicio
END
