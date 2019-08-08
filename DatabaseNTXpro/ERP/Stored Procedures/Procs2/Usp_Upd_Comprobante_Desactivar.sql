
CREATE PROC [ERP].[Usp_Upd_Comprobante_Desactivar]
@IdComprobante			INT
AS
BEGIN
	UPDATE ERP.Comprobante SET Flag = 0 ,FechaEliminado = GETDATE() WHERE ID = @IdComprobante
END
