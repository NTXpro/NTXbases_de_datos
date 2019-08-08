
CREATE PROC [ERP].[Usp_Upd_Empresa_Desactivar]
@IdEmpresa			INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Empresa SET Flag = 0, UsuarioElimino = @UsuarioElimino , FechaEliminado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdEmpresa
END
