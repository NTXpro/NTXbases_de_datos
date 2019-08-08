CREATE PROC [ERP].[Usp_Del_Proyecto]
@IdProyecto		INT
AS
BEGIN
		DELETE FROM [ERP].[Proyecto] WHERE ID = @IdProyecto
END
