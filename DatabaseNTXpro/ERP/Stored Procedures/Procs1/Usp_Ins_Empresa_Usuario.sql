create PROC ERP.Usp_Ins_Empresa_Usuario
@IdEmpresa		INT,
@IdUsuario	INT
AS
BEGIN

	INSERT INTO ERP.EmpresaUsuario (IdUsuario, IdEmpresa) VALUES(@IdUsuario,@IdEmpresa)
END