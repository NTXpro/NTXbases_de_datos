
create PROC [ERP].[Usp_Del_AjusteCuentaPagar]
@ID INT
AS
BEGIN
	DELETE FROM [ERP].[AjusteCuentaPagar] WHERE ID = @ID
END
