CREATE PROC ERP.Usp_Upd_Operacion_Desactivar
@IdOperacion INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN

		UPDATE ERP.Operacion  SET Flag = 0,
								  UsuarioElimino = @UsuarioElimino,
								  FechaEliminado = DATEADD(HOUR, 3, GETDATE())
								  WHERE ID = @IdOperacion
END
