CREATE PROC [ERP].[Usp_Sel_RendirCuenta_By_ID]
@IdRendirCuenta INT
AS
BEGIN
	SELECT MRC.ID
		  ,MRC.IdMovimientoTesoreria
		  ,MRC.Orden OrdenRendirCuenta
		  ,MRC.Total
		  ,MRC.ToTalGastado
		  ,MRC.Flag
		  ,MRC.FlagCierre
		  ,MRC.FlagBorrador
		  ,MRC.IdPeriodo
		  ,MRC.IdEmpresa
		  ,MRC.FechaEmision
		  ,MRC.TipoCambio
		  ,MRC.FechaRegistro
		  ,MRC.FechaModificado
		  ,MRC.UsuarioModifico
		  ,MRC.UsuarioRegistro
		  ,MT.Orden OrdenMovimiento
		  ,MT.Nombre NombreMovimiento
		  ,MT.IdCuenta
		  ,C.IdMoneda
		  ,(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](C.ID)) NombreBancoMonedaTipo
	FROM ERP.MovimientoRendirCuenta MRC
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MRC.IdMovimientoTesoreria
	INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
	WHERE MRC.ID = @IdRendirCuenta

END
