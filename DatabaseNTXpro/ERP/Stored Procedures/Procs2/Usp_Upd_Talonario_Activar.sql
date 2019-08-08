CREATE PROC ERP.Usp_Upd_Talonario_Activar
@IdTalonario INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	
	UPDATE ERP.Talonario SET UsuarioActivo = @UsuarioActivo, Flag = 1, FechaActivacion = DATEADD(HOUR,3,GETDATE()) 
	WHERE ID = @IdTalonario

END