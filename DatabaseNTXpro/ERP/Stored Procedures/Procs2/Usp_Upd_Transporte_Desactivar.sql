
CREATE PROC ERP.Usp_Upd_Transporte_Desactivar
@IdTransporte			INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Transporte SET Flag = 0, UsuarioElimino = @UsuarioElimino , FechaEliminado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdTransporte
END
