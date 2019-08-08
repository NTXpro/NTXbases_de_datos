CREATE proc ERP.Usp_Sel_Report_MovimientoTesoreria_By_ID
@ID INT
AS
BEGIN
	SELECT	MT.ID,
			MT.Orden,
			(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MT.IdCuenta)) Cuenta,
			CASE WHEN MT.IdTipoMovimiento = 1 THEN
				'VOUCHER DE INGRESOS'
			ELSE
				'VOUCHER DE EGRESOS'
			END Titulo,
			MT.Voucher,
			MT.Nombre,
			MT.Observacion,
			MT.Fecha,
			M.Simbolo,
			UPPER(CTM.Codigo +' - '+ CTM.Nombre) Operacion
	FROM ERP.MovimientoTesoreria MT
	LEFT JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
	LEFT JOIN Maestro.Moneda M ON M.ID = MT.IdMoneda
	WHERE MT.ID = @ID
END