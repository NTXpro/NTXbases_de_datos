CREATE PROC [Maestro].[Usp_Del_Origen]
@ID INT
AS
BEGIN
	DELETE FROM [Maestro].[Origen] 
	WHERE ID = @ID
END
