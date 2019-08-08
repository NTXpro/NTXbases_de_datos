
CREATE PROC [ERP].[Usp_Upd_PlanCuenta_Borrador]
@PlanCuenta	INT,
@Nombre			VARCHAR(50)
AS
BEGIN
		UPDATE [ERP].[PlanCuenta] SET Nombre= @Nombre  WHERE ID=@PlanCuenta
END
