
CREATE PROC [ERP].[Usp_Validar_Nombre_Producto]
@ID INT,
@Nombre VARCHAR(50),
@IdEmpresa INT,
@IdUnidadMedida INT
AS
BEGIN

	DECLARE @COUNT INT = (SELECT COUNT(ID) FROM [ERP].[Producto] WHERE ID != @ID AND Nombre = @Nombre AND Flag = 1 AND FlagBorrador = 0 AND IdEmpresa= @IdEmpresa AND IdUnidadMedida = @IdUnidadMedida)

	SELECT ISNULL(@COUNT,0)
END
