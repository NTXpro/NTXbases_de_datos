CREATE PROC ERP.Usp_Del_CajaChica
@ID INT
AS
BEGIN
	DELETE FROM ERP.MovimientoCajaChicaDetalle WHERE IdMovimientoCajaChica = @ID
	DELETE FROM ERP.MovimientoCajaChica WHERE ID = @ID
END