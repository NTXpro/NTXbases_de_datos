CREATE PROC ERP.Usp_Del_Familia_Producto
@IdProducto INT,
@IdFamilia INT,
@IdEmpresa INT
AS
BEGIN
		DELETE ERP.FamiliaProducto WHERE IdProducto = @IdProducto AND IdFamilia = @IdFamilia AND IdEmpresa = @IdEmpresa
END
