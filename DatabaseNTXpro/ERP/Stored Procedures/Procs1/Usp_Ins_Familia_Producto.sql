
CREATE PROC [ERP].[Usp_Ins_Familia_Producto]
@IdFamiliaProducto INT OUT,
@IdProducto INT,
@IdFamilia INT,
@IdEmpresa INT
AS
BEGIN

		DELETE ERP.FamiliaProducto WHERE IdProducto = @IdProducto AND IdEmpresa = @IdEmpresa

		INSERT INTO ERP.FamiliaProducto(IdProducto,
										IdFamilia,
										IdEmpresa)
										VALUES(@IdProducto,
											   @IdFamilia,
											   @IdEmpresa)

		SET @IdFamiliaProducto = SCOPE_IDENTITY();
END
