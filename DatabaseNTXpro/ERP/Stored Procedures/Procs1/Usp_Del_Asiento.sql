CREATE PROC [ERP].[Usp_Del_Asiento]
@ID INT
AS
BEGIN
	DELETE FROM [ERP].[AsientoDetalle] WHERE IdAsiento = @ID
	DELETE FROM [ERP].[Asiento] WHERE ID = @ID
END
