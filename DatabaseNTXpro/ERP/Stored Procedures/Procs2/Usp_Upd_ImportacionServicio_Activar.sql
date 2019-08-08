
CREATE PROC ERP.Usp_Upd_ImportacionServicio_Activar
@IdImporteServicio INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
			UPDATE Maestro.ImportacionServicio	SET	UsuarioActivo = @UsuarioActivo,
													FechaActivacion = DATEADD(HOUR, 3, GETDATE()),
													Flag = 1
													WHERE ID = @IdImporteServicio
END
