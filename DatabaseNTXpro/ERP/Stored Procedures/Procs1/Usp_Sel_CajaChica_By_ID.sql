CREATE PROC [ERP].[Usp_Sel_CajaChica_By_ID]
@ID INT
AS
BEGIN
	SELECT MCC.ID
	  ,MCC.IdEmpresa
      ,MCC.Orden
      ,MCC.TipoCambio
      ,MCC.IdCuenta
	  ,C.Nombre NombreCuenta
      ,MCC.FechaEmision
      ,MCC.FechaCierre
      ,MCC.SaldoInicial
	  ,MCC.SaldoFinal
      ,MCC.TotalGastado
      ,MCC.IdEmpresa
      ,MCC.FechaRegistro
      ,MCC.FechaModificado
      ,MCC.UsuarioModifico
      ,MCC.UsuarioRegistro
      ,MCC.Flag
      ,MCC.FlagBorrador
	  ,MCC.FlagCierre
	  ,[ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MCC.IdCuenta) AS NombreCuentaBancoMoneda
	  ,C.IdMoneda
	  ,MCC.Documento
	  ,MCC.Observacion
  FROM ERP.MovimientoCajaChica MCC
  INNER JOIN ERP.Cuenta C ON C.ID = MCC.IdCuenta 
  WHERE MCC.ID = @ID
END