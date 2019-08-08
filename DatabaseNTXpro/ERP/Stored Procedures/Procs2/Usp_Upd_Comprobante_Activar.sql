
CREATE PROC [ERP].[Usp_Upd_Comprobante_Activar]
@IdComprobante			INT
AS
BEGIN
	UPDATE ERP.Comprobante SET Flag = 1 ,FechaEliminado = NULL WHERE ID = @IdComprobante
END
