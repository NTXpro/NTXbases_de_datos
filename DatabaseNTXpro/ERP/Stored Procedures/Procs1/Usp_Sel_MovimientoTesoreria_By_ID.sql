CREATE PROC [ERP].[Usp_Sel_MovimientoTesoreria_By_ID]
@ID INT
AS
BEGIN
	
	SELECT	MT.ID,
			MT.Orden,
			MT.Nombre NombreMovimiento,
			MT.Fecha,
			MT.FechaVencimiento,
			MT.TipoCambio,
			MT.Voucher,
			MT.NumeroCheque,
			MT.Observacion,
			MT.Total,
			MT.UsuarioRegistro,
			MT.UsuarioElimino,
			MT.UsuarioActivo,
			MT.UsuarioModifico,
			MT.FechaRegistro,
			MT.FechaModificado,
			MT.FechaEliminado,
			MT.FechaActivacion,
			MT.IdPeriodo,
			MT.IdCuenta,
			C.Nombre NombreCuenta,
			MT.IdMoneda,
			MT.IdTipoMovimiento,
			TM.Nombre NombreTipoMovimiento,
			MT.IdEntidad,
			E.Nombre NombreEntidad,
			MT.IdTalonario,
			(T.Inicio+ ' - ' + T.Fin) NombreTalonario,
			MT.IdCategoriaTipoMovimiento,
			CTM.Nombre NombreCategoriaTipoMovimiento,
			MT.Flag,
			MT.FlagTransferencia,
			MT.FlagCajaChica,
			MT.FlagCheque,
			MT.FlagChequeDiferido,
			C.IdEntidad IdEntidadCuenta
	FROM ERP.MovimientoTesoreria MT
	LEFT JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
	LEFT JOIN Maestro.TipoMovimiento TM ON TM.ID = MT.IdTipoMovimiento
	LEFT JOIN ERP.Entidad E ON E.ID = MT.IdEntidad
	LEFT JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
	LEFT JOIN ERP.Talonario T ON T.ID = MT.IdTalonario
	WHERE MT.ID = @ID
END
