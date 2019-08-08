CREATE PROC [ERP].[Usp_Sel_MovimientoCajaChica_Borrador]
@IdEmpresa INT
AS
BEGIN
	SELECT ID,
		   [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](MCC.IdCuenta) AS NombreCuentaBancoMoneda,
		   TotalGastado,
		   FechaEmision 
	FROM ERP.MovimientoCajaChica MCC
	WHERE FlagBorrador = 1 AND IdEmpresa = @IdEmpresa
END