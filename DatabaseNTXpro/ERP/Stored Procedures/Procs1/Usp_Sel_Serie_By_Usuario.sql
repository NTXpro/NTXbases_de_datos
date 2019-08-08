
CREATE PROC [ERP].[Usp_Sel_Serie_By_Usuario]
@IdUsuario INT,
@IdEmpresa INT,
@IdTipoComprobante INT
AS
BEGIN
	
	DECLARE @Serie CHAR(4)=(SELECT TOP 1 Serie 
							FROM ERP.Comprobante WHERE IdUsuario = @IdUsuario AND IdEmpresa = @IdEmpresa AND IdTipoComprobante = @IdTipoComprobante AND FlagBorrador = 0
							ORDER BY FechaRegistro DESC)

	SELECT @Serie
END
