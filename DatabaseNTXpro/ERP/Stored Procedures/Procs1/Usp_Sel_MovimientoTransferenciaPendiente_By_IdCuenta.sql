CREATE PROC [ERP].[Usp_Sel_MovimientoTransferenciaPendiente_By_IdCuenta]
@IdCuenta INT
AS
BEGIN
	SELECT MT.ID,
		   MT.Orden,
		   MT.Nombre,
		   MT.FechaRegistro ,
		   MT.TipoCambio,
		   MT.Total,
		   MT.Fecha FechaEmision
	FROM ERP.MovimientoTesoreria MT
	INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
	WHERE MT.Flag = 1 AND MT.FlagBorrador = 0 AND (MT.FlagRindioCuenta = 0 OR MT.FlagRindioCuenta IS NULL)
	AND MT.IdCuenta = @IdCuenta AND MT.IdTipoMovimiento = 1 AND MT.FlagTransferencia = 1
	AND C.IdTipoCuenta = 7
END
