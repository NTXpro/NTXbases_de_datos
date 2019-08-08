CREATE PROC ERP.Usp_Sel_Talonario_Inactivo
@IdEmpresa INT
AS
BEGIN
	SELECT	ID,
			(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](IdCuenta)) NombreBancoMonedaTipo,
			Inicio,
			Fin,
			FechaRegistro
	FROM ERP.Talonario
	WHERE IdEmpresa = @IdEmpresa AND FLAG = 0
END