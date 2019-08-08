CREATE PROC ERP.Usp_Validar_Nombre_ListaPrecio
@Nombre VARCHAR(50),
@ID INT,
@IdEmpresa INT
AS
BEGIN
	DECLARE @COUNT INT = (SELECT COUNT(ID) FROM [ERP].[ListaPrecio] WHERE ID != @ID AND Nombre = @Nombre AND IdEmpresa = @IdEmpresa AND Flag = 1 AND FlagBorrador = 0)

	SELECT ISNULL(@COUNT,0)
END

