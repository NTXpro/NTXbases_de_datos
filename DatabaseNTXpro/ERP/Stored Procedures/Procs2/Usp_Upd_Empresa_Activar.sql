CREATE PROC [ERP].[Usp_Upd_Empresa_Activar]
@IdEmpresa			INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Empresa SET Flag = 1, UsuarioActivo = @UsuarioActivo, FechaActivacion =  DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdEmpresa
END