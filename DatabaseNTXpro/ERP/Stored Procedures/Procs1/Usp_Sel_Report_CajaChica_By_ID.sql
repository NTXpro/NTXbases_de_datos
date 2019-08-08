
CREATE proc [ERP].[Usp_Sel_Report_CajaChica_By_ID]
@ID INT
AS
BEGIN
	SELECT	MCC.ID,
			MCC.Orden,
			(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MCC.IdCuenta)) Cuenta,
			'VOUCHER DE EGRESOS' Titulo,
			MCC.Documento Voucher,
			MCC.Observacion Nombre,
			MCC.Observacion,
			MCC.FechaEmision Fecha,
			M.Simbolo,
			UPPER(CTM.Codigo +' - '+ CTM.Nombre) Operacion
	FROM ERP.MovimientoCajaChica MCC
	LEFT JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = 26
	LEFT JOIN ERP.Cuenta C ON C.ID = MCC.IdCuenta
	LEFT JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
	WHERE MCC.ID = @ID
END