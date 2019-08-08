CREATE PROC ERP.Usp_Del_AjusteCuentaCobrar
@ID INT
AS
BEGIN
	DELETE FROM [ERP].[AjusteCuentaCobrar] WHERE ID = @ID
END
