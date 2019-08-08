CREATE PROC ERP.Usp_Del_MovimientoTransferencia
@ID INT
AS
BEGIN
	DELETE FROM ERP.MovimientoTransferenciaCuenta WHERE ID = @ID
END