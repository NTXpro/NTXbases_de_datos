
CREATE proc [ERP].[Usp_Sel_Report_RendirCuenta_By_ID]
@ID INT
AS
BEGIN
	SELECT	MRC.ID,
			MRC.Orden,
			(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MT.IdCuenta)) Cuenta,
			'VOUCHER DE EGRESOS' Titulo,
			'' Voucher,
			'' Nombre,
			'' Observacion,
			MRC.FechaEmision Fecha,
			M.Simbolo,
			UPPER(CTM.Codigo +' - '+ CTM.Nombre) Operacion
	FROM ERP.MovimientoRendirCuenta MRC
	LEFT JOIN ERP.MovimientoTesoreria MT ON MT.ID = MRC.IdMovimientoTesoreria
	LEFT JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = 26
	LEFT JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
	LEFT JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
	WHERE MRC.ID = @ID
END