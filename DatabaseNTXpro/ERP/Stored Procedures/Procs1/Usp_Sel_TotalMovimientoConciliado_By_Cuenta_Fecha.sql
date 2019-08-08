CREATE PROC ERP.Usp_Sel_TotalMovimientoConciliado_By_Cuenta_Fecha
@IdCuenta INT,
@Fecha DATETIME
AS
BEGIN
	SELECT [ERP].[ObtenerTotalMovimientoConciliadoByCuentaFecha](@IdCuenta,@Fecha)
END