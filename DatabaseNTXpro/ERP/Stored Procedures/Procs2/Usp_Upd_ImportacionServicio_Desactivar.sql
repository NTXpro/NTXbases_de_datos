
CREATE PROC ERP.Usp_Upd_ImportacionServicio_Desactivar
@IdImporteServicio INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
			UPDATE Maestro.ImportacionServicio	SET	UsuarioElimino = @UsuarioElimino,
													FechaEliminado = DATEADD(HOUR, 3, GETDATE()),
													Flag = 1 
													WHERE ID = @IdImporteServicio
END
