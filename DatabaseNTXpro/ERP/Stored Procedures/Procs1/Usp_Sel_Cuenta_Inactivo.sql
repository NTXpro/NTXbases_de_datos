

CREATE PROC [ERP].[Usp_Sel_Cuenta_Inactivo]
@IdEmpresa INT
AS
BEGIN

		SELECT	C.ID,
				C.Nombre,
				E.Nombre AS NombreBanco,
				PC.CuentaContable,
				PC.Nombre AS NombrePlanCuenta
		FROM ERP.Cuenta C
		LEFT JOIN ERP.Entidad E
			ON E.ID = C.IdEntidad
		LEFT JOIN ERP.PlanCuenta PC
			ON PC.ID = C.IdPlanCuenta
		WHERE C.Flag = 0 AND C.IdEmpresa = @IdEmpresa
END

