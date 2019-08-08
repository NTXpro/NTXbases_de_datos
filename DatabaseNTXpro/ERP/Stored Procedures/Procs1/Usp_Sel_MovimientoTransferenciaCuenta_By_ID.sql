CREATE PROC [ERP].[Usp_Sel_MovimientoTransferenciaCuenta_By_ID] --7
@IdTransferencia INT
AS
BEGIN
SELECT MTC.ID,
	   MTC.IdCuentaEmisor,
	   CE.Nombre NombreCuentaEmisor,
	   (SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MTC.IdCuentaEmisor)) AS NombreCuentaBancoMonedaEmisor,
	   MTC.IdCategoriaTipoMovimientoEmisor,
	   CTME.Nombre NombreCategoriaTipoMovimientoEmisor,
	   TE.ID IdTalonarioEmisor,
	   (CAST(TE.Inicio AS VARCHAR(20)) +' - '+ CAST(TE.Fin AS VARCHAR(20))) NombreTalonarioEmisor,
	   MTC.NumeroChequeEmisor,
	   MTC.FechaEmisor,
	   MTC.FechaVencimientoEmisor,
	   MTC.TipoCambioEmisor,
	   MTC.MontoEmisor,
	   MTC.OrdenDeEmisor,
	   MTC.AjusteEmisor,
	   MTC.ConceptoEmisor,
	   MTC.ObservacionEmisor,
	   MTC.IdCuentaReceptor,
	   CR.Nombre NombreCuentaReceptor,
	   (SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MTC.IdCuentaReceptor)) AS NombreCuentaBancoMonedaReceptor,
	   MTC.IdCategoriaTipoMovimientoReceptor,
	   CTMR.Nombre NombreCategoriaTipoMovimientoReceptor,
	   MTC.FechaReceptor,
	   MTC.DocumentoReceptor,
	   MTC.TipoCambioReceptor,
	   MTC.MontoReceptor,
	   MTC.ConceptoReceptor,
	   MTC.ObservacionReceptor,
	   MTE.Orden NumeroMovimientoEmisor,
	   MTR.Orden NumeroMovimientoReceptor,
	   MTC.Flag,
	   MTC.FlagCajaChica,
	   MTC.FlagCheque,
	   MTC.FlagChequeDiferido,
	   CE.IdEntidad IdEntidadEmisor,
	   ER.Nombre NombreEntidadReceptor
FROM ERP.MovimientoTransferenciaCuenta MTC
LEFT JOIN ERP.MovimientoTesoreria MTE ON MTE.ID = MTC.IdMovimientoTesoreriaEmisor
LEFT JOIN ERP.MovimientoTesoreria MTR ON MTR.ID = MTC.IdMovimientoTesoreriaReceptor
LEFT JOIN ERP.Cuenta CE ON CE.ID = MTC.IdCuentaEmisor
LEFT JOIN ERP.Cuenta CR ON CR.ID = MTC.IdCuentaReceptor
LEFT JOIN ERP.Entidad ER ON ER.ID = CR.IdEntidad
LEFT JOIN Maestro.CategoriaTipoMovimiento CTME ON CTME.ID = MTC.IdCategoriaTipoMovimientoEmisor
LEFT JOIN Maestro.CategoriaTipoMovimiento CTMR ON CTMR.ID = MTC.IdCategoriaTipoMovimientoReceptor
LEFT JOIN ERP.Talonario TE ON TE.ID = MTC.IdTalonarioEmisor
WHERE MTC.ID = @IdTransferencia
END
