CREATE PROC [ERP].[Usp_Del_Planilla]
@ID INT
AS
BEGIN
	DELETE FROM [Maestro].[Planilla] WHERE ID = @ID
END
