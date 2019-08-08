CREATE PROC [ERP].[Usp_Validar_Nombre_Existencia]
@ID INT,
@Nombre VARCHAR(50)
AS
BEGIN

	DECLARE @COUNT INT = (SELECT COUNT(ID) FROM [PLE].[T5Existencia] WHERE ID != @ID AND Nombre = @Nombre AND Flag = 1 AND FlagBorrador = 0)

	SELECT ISNULL(@COUNT,0)
END
