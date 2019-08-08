

CREATE PROC [ERP].[Usp_Upd_Cuenta_Activar]
@IdCuenta			INT,
@UsuarioActivo		VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Cuenta SET Flag = 1 ,UsuarioActivo = @UsuarioActivo, FechaActivacion = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdCuenta
END
