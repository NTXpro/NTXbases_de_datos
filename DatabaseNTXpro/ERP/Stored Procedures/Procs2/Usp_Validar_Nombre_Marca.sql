
CREATE PROC [ERP].[Usp_Validar_Nombre_Marca]
@ID INT,
@Nombre VARCHAR(50)
AS
BEGIN

	DECLARE @COUNT INT = (SELECT COUNT(ID) FROM [Maestro].[Marca] WHERE ID != @ID AND Nombre = @Nombre AND Flag = 1 AND FlagBorrador = 0)

	SELECT ISNULL(@COUNT,0)
END