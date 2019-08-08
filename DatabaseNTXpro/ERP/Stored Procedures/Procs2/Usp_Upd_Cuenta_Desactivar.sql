

CREATE PROC [ERP].[Usp_Upd_Cuenta_Desactivar]
@IdCuenta			INT,
@UsuarioElimino		VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Cuenta SET Flag = 0, UsuarioElimino = @UsuarioElimino, FechaEliminado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdCuenta
END
