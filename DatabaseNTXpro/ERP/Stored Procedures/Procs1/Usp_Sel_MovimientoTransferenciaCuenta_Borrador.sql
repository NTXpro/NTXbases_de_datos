CREATE PROC ERP.Usp_Sel_MovimientoTransferenciaCuenta_Borrador
@IdEmpresa INT
AS
BEGIN
SELECT MTC.ID,
        MTC.FechaEmisor,
	    CE.Nombre NombreCuentaEmisor,
	    CTME.Nombre NombreCategoriaTipoMovimientoEmisor,
	    MTC.MontoEmisor,
	    CR.Nombre NombreCuentaReceptor,
	    CTMR.Nombre NombreCategoriaTipoMovimientoReceptor,
	    MTC.MontoReceptor
FROM ERP.MovimientoTransferenciaCuenta MTC
LEFT JOIN ERP.Cuenta CE ON CE.ID = MTC.IdCuentaEmisor
LEFT JOIN ERP.Cuenta CR ON CR.ID = MTC.IdCuentaReceptor
LEFT JOIN Maestro.CategoriaTipoMovimiento CTME ON CTME.ID = MTC.IdCategoriaTipoMovimientoEmisor
LEFT JOIN Maestro.CategoriaTipoMovimiento CTMR ON CTMR.ID = MTC.IdCategoriaTipoMovimientoReceptor
WHERE MTC.IdEmpresa = @IdEmpresa AND MTC.FlagBorrador = 1
END