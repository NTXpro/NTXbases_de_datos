
create PROC [ERP].[Usp_Upd_OrdenPago_Anular]
@ID INT
AS
BEGIN
	UPDATE ERP.OrdenPago SET FLAG = 0 WHERE ID = @ID
END