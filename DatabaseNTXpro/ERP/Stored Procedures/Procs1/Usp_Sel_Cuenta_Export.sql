CREATE PROCEDURE [ERP].[Usp_Sel_Cuenta_Export]
@Flag BIT,
@IdEmpresa INT
AS
BEGIN
SELECT               
				C.ID,
				C.Nombre,
				E.Nombre AS NombreBanco,
				PC.CuentaContable,
				PC.Nombre AS NombrePlanCuenta
		FROM ERP.Cuenta C 
		INNER JOIN ERP.Entidad E
			ON E.ID = C.IdEntidad
		INNER JOIN ERP.PlanCuenta PC
			ON PC.ID = C.IdPlanCuenta
		WHERE C.Flag = @Flag AND E.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa
END
