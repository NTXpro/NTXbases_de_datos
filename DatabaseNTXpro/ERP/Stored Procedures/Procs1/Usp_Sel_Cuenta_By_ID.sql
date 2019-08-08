CREATE PROC [ERP].[Usp_Sel_Cuenta_By_ID]
@IdCuenta INT
AS
BEGIN
	SELECT C.ID,
		   C.CuentaInterbancario,
		   C.Nombre,
		   Fecha,
		   SaldoInicialDebe,
		   SaldoInicialHaber,
		   M.ID  IdMoneda,
		   M.Nombre NombreMoneda,
		   TC.ID IdTipoCuenta,
		   TC.Nombre NombreTipoCuenta,
		   PC.ID IdPlanCuenta,
		   PC.Nombre NombrePlanCuenta,
			PC.CuentaContable,
		   C.FechaRegistro,
		   C.FechaEliminado,
		   C.FechaModificado,
		   C.FechaActivacion,
		   C.UsuarioRegistro,
		   C.UsuarioElimino,
		   C.UsuarioModifico,
		   C.UsuarioActivo,
		   C.FlagDetraccion,
		   C.FlagContabilidad,
		   C.IdEntidad,
		   E.Nombre NombreEntidad,
		   ETD.NumeroDocumento NumeroDocumentoEntidad,
		   ISNULL(C.MostrarEnFE, 0) MostrarEnFE
	FROM ERP.Cuenta C 
	LEFT JOIN ERP.Entidad E ON E.ID = C.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = C.IdEntidad
	LEFT JOIN PLE.T3Banco B ON B.IdEntidad = C.IdEntidad
	LEFT JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
	LEFT JOIN Maestro.TipoCuenta TC ON TC.ID = C.IdTipoCuenta
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = C.IdPlanCuenta
	WHERE C.ID = @IdCuenta
END