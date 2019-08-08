CREATE PROC ERP.Usp_Sel_TotalMovimiento_By_Cuenta_Fecha
@IdCuenta INT,
@Fecha DATETIME
AS
BEGIN
	SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](@IdCuenta,@Fecha);
END