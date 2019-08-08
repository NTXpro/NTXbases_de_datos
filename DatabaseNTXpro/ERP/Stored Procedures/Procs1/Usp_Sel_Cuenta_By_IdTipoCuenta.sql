
CREATE PROC [ERP].[Usp_Sel_Cuenta_By_IdTipoCuenta]
@IdEmpresa INT,
@IdTipoCuenta INT
AS
BEGIN
	SELECT  C.ID,
			C.Nombre,
			E.ID     IdEntidadBanco,
			E.Nombre NombreBanco,
			M.ID	 IdMoneda,
			M.Nombre NombreMoneda,
			IdTipoCuenta,
			TC.Nombre NombreTipoCuenta,
			C.IdPlanCuenta
	FROM ERP.Cuenta C
	LEFT JOIN PLE.T3Banco B ON B.IdEntidad = C.IdEntidad
	INNER JOIN ERP.Entidad E ON E.ID = C.IdEntidad
	INNER JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
	INNER JOIN Maestro.TipoCuenta TC ON TC.ID = C.IdTipoCuenta 
	WHERE C.IdEmpresa = @IdEmpresa AND IdTipoCuenta = @IdTipoCuenta
	AND C.FlagBorrador = 0 AND C.FLAG = 1
END