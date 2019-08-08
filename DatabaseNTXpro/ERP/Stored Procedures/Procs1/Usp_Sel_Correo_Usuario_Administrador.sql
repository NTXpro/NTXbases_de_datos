CREATE PROC ERP.Usp_Sel_Correo_Usuario_Administrador
AS
BEGIN
	
	DECLARE @Correo VARCHAR(250) = (SELECT TOP 1 Correo FROM [Seguridad].[Usuario] WHERE FlagAdministrador = 1)

	SELECT @Correo
END