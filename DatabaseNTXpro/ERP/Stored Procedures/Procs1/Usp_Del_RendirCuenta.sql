
CREATE PROC [ERP].[Usp_Del_RendirCuenta]
@ID INT
AS
BEGIN
	DELETE FROM ERP.MovimientoRendirCuentaDetalle WHERE IdMovimientoRendirCuenta = @ID
	DELETE FROM ERP.MovimientoRendirCuenta WHERE ID = @ID
END