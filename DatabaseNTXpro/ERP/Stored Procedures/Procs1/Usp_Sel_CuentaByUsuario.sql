CREATE PROC [ERP].[Usp_Sel_CuentaByUsuario]
@IdEmpresa INT,
@IdEntidad INT 
AS
BEGIN
	SELECT  C.ID,
			C.Nombre,
			E.ID     IdEntidad,
			ETD.NumeroDocumento,
			B.ID IdBanco,
			E.Nombre NombreBanco,
			M.ID	 IdMoneda,
			M.Nombre NombreMoneda,
			IdTipoCuenta,
			TC.Nombre NombreTipoCuenta,
			C.IdPlanCuenta,
			PC.CuentaContable,
			ISNULL(C.MostrarEnFE, 0) MostrarEnFE
	FROM ERP.Cuenta C
	INNER JOIN ERP.Entidad E ON E.ID = C.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
	LEFT JOIN PLE.T3Banco B ON B.IdEntidad = C.IdEntidad
	INNER JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
	INNER JOIN Maestro.TipoCuenta TC ON TC.ID = C.IdTipoCuenta 
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = C.IdPlanCuenta
	--INNER JOIN Seguridad.Usuario U ON U.IdEntidad = C.IdEntidad
	WHERE C.IdEmpresa = @IdEmpresa AND C.FlagBorrador = 0 AND C.FLAG = 1 and C.IdEntidad = @IdEntidad
END