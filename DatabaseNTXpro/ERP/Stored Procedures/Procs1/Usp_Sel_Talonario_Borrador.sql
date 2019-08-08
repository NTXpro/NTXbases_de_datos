
CREATE PROC [ERP].[Usp_Sel_Talonario_Borrador]
@IdEmpresa INT
AS
BEGIN
	SELECT	ID,
			(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](IdCuenta)) NombreBancoMonedaTipo,
			Inicio,
			Fin,
			FechaRegistro
	FROM ERP.Talonario
	WHERE IdEmpresa = @IdEmpresa AND FlagBorrador = 1
END