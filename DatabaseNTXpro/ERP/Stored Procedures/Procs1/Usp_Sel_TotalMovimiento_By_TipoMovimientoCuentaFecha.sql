create proc ERP.Usp_Sel_TotalMovimiento_By_TipoMovimientoCuentaFecha
@IdEmpresa INT,
@IdTipoMovimiento INT,
@IdCuenta INT,
@Mes INT,
@Anio INT
AS
BEGIN
	SELECT [ERP].[ObtenerTotalMovimientoByTipoMovimientoCuentaFecha](@IdEmpresa,@IdTipoMovimiento,@IdCuenta,@Mes,@Anio)
END