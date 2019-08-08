CREATE PROC ERP.Usp_Upd_Operacion_Activar
@IdOperacion INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN

		UPDATE ERP.Operacion  SET Flag = 1,
								  UsuarioActivo = @UsuarioActivo,
								  FechaActivacion = DATEADD(HOUR, 3, GETDATE())
								  WHERE ID = @IdOperacion
END
