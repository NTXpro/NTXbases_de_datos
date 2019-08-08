
CREATE PROC [ERP].[Usp_Sel_Establecimiento_By_Usuario]
@IdUsuario INT,
@IdEmpresa INT
AS
BEGIN
	
	DECLARE @IdEstablecimiento INT= (SELECT TOP 1 IdEstablecimiento 
							FROM ERP.Comprobante WHERE IdUsuario = @IdUsuario AND IdEmpresa = @IdEmpresa
							ORDER BY FechaRegistro DESC)

	SELECT ISNULL(@IdEstablecimiento,0)
END
