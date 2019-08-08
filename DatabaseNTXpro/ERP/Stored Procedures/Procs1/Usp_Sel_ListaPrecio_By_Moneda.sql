CREATE PROC ERP.Usp_Sel_ListaPrecio_By_Moneda
@IdMoneda INT,
@IdEmpresa INT
AS
BEGIN

	SELECT ID,Nombre FROM ERP.ListaPrecio WHERE IdMoneda = @IdMoneda AND IdEmpresa = @IdEmpresa

END