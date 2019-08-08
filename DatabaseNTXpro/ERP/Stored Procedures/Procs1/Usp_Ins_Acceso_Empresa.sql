

CREATE PROC [ERP].[Usp_Ins_Acceso_Empresa]
@IdEmpresa INT
AS
BEGIN
	
	DECLARE @IdUsuarioAdministrador INT = (SELECT TOP 1 ID FROM Seguridad.Usuario WHERE FlagAdministrador = 1)

	INSERT INTO ERP.EmpresaUsuario(IdEmpresa,IdUsuario) VALUES (@IdEmpresa,@IdUsuarioAdministrador)
END