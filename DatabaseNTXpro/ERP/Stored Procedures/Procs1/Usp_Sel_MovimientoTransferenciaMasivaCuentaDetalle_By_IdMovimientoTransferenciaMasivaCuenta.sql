CREATE PROC ERP.Usp_Sel_MovimientoTransferenciaMasivaCuentaDetalle_By_IdMovimientoTransferenciaMasivaCuenta
@IdMovimientoTransferenciaMasivaCuenta int
AS
BEGIN
	SELECT 
	   MTMC.ID
      ,MTMC.IdCuentaReceptor
      ,MTMC.IdCategoriaTipoMovimientoReceptor
      ,MTMC.IdProyecto
      ,MTMC.IdDebeHaber
      ,MTMC.IdMovimientoTesoreriaReceptor
      ,MTMC.MontoReceptor
      ,MTMC.IdMovimientoTransferenciaMasivaCuenta
      ,MTMC.Orden
	  ,(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MTMC.IdCuentaReceptor)) AS NombreCuentaBancoMonedaReceptor
	  ,P.Numero NumeroProyecto
	  ,DH.Nombre DebeHaber
	  ,MT.Orden NumeroMovimientoReceptor
	FROM ERP.MovimientoTransferenciaMasivaCuentaDetalle MTMC
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTMC.IdMovimientoTesoreriaReceptor
	INNER JOIN Maestro.DebeHaber DH ON DH.ID = MTMC.IdDebeHaber
	LEFT JOIN ERP.Proyecto P ON P.ID = MTMC.IdProyecto
	WHERE MTMC.IdMovimientoTransferenciaMasivaCuenta = @IdMovimientoTransferenciaMasivaCuenta
END
