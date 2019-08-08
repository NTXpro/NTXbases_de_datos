/*SE OBTIENE EL SALDO INICIAL DE LA CUENTA A PARTIR DE UNA CIERTA FECHA HACIA ATRAS
EJEMPLO: CUENTA 1 , FECHA ENERO 2015
SE OBTIENE EL MONTO INICIAL HASTA ESA FECHA
OSEA LOS MOVIMIENTOS GENERADOS EN ENERO NO SE DEBEN VISUALIZAR SOLO LOS DE ENERO HACIA ATRAS(...NOVIEMBRE,DICIEMBRE 2014)
*/
CREATE FUNCTION [ERP].[ObtenerTotalMovimientoByTipoMovimientoCuentaFecha](
@IdEmpresa INT,
@IdTipoMovimiento INT,
@IdCuenta INT,
@Mes INT,
@Anio INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN

	DECLARE @TotalMovimiento DECIMAL(14,5) = (SELECT SUM(MT.Total)
														FROM ERP.MovimientoTesoreria MT
														INNER JOIN ERP.Cuenta C ON  C.ID = MT.IdCuenta
														WHERE (@IdCuenta = 0 OR MT.IdCuenta = @IdCuenta)   
														 AND ((YEAR(MT.Fecha) = @Anio AND MONTH(MT.Fecha) = @Mes))
														AND MT.IdTipoMovimiento = @IdTipoMovimiento AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MT.IdEmpresa = @IdEmpresa
														)

	RETURN ISNULL(@TotalMovimiento,0) 
END


