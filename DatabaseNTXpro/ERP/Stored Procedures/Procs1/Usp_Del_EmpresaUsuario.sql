CREATE PROC ERP.Usp_Del_EmpresaUsuario
@IdUsuario INT
AS
BEGIN
	DELETE FROM ERP.EmpresaUsuario WHERE IdUsuario = @IdUsuario
END