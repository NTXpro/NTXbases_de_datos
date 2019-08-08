
CREATE PROC ERP.Usp_Upd_Transporte_Activar
@IdTransporte			INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Transporte SET Flag = 1, UsuarioActivo = @UsuarioActivo, FechaActivacion =  DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdTransporte
END
