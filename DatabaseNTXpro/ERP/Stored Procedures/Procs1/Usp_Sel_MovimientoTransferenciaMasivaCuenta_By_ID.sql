CREATE PROC [ERP].[Usp_Sel_MovimientoTransferenciaMasivaCuenta_By_ID]
@ID int
AS
BEGIN
	SELECT MTMC.ID
		  ,MTMC.IdCuentaEmisor
		  ,MTMC.IdCategoriaTipoMovimientoEmisor
		  ,MTMC.IdMovimientoTesoreriaEmisor
		  ,MTMC.IdTalonarioEmisor
		  ,MTMC.NumeroChequeEmisor
		  ,MTMC.FechaEmisor
		  ,MTMC.FechaVencimientoEmisor
		  ,MTMC.TipoCambioEmisor
		  ,MTMC.MontoEmisor
		  ,MTMC.AjusteEmisor
		  ,MTMC.DocumentoEmisor
		  ,MTMC.ObservacionEmisor
		  ,MTMC.OrdenDeEmisor
		  ,MTMC.FlagChequeDiferido
		  ,MTMC.FlagCheque
		  ,MTMC.FechaRegistro
		  ,MTMC.UsuarioRegistro
		  ,MTMC.FechaModificado
		  ,MTMC.UsuarioModifico
		  ,MTMC.IdEmpresa
		  ,MTMC.Flag
		  ,MTMC.FlagBorrador
		  ,(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MTMC.IdCuentaEmisor)) AS NombreCuentaBancoMonedaEmisor
		  ,CTM.Nombre NombreCategoriaTipoMovimientoEmisor
		  ,MT.Orden NumeroMovimientoEmisor
		  ,(T.Inicio + '-' + T.Fin) AS NombreTalonarioEmisor
	  FROM ERP.MovimientoTransferenciaMasivaCuenta MTMC
	  INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTMC.IdMovimientoTesoreriaEmisor
	  INNER JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MTMC.IdCategoriaTipoMovimientoEmisor
	  LEFT JOIN ERP.Talonario T ON T.ID = MTMC.IdTalonarioEmisor
	  WHERE MTMC.ID = @ID
END
