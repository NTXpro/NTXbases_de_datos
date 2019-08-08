CREATE PROC [ERP].[Usp_Validar_Nombre_Proyecto]
@ID INT,
@IdEmpresa INT,
@Nombre VARCHAR(50)
AS
BEGIN

	DECLARE @COUNT INT = (SELECT COUNT(ID) FROM [ERP].[Proyecto] WHERE ID != @ID AND Nombre = @Nombre AND IdEmpresa = @IdEmpresa AND Flag = 1 AND FlagBorrador = 0)

	SELECT ISNULL(@COUNT,0)
END