
CREATE FUNCTION [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](@IdCuenta INT)
RETURNS VARCHAR(250)
AS
BEGIN

	DECLARE @NombreBancoMonedaTipo VARCHAR(250) = (	SELECT TOP 1  E.Nombre+' - '+ TC.Nombre+ ' - '+C.Nombre+' - '+ M.Nombre
													FROM ERP.Cuenta C
													INNER JOIN ERP.Entidad E ON E.ID = C.IdEntidad
													INNER JOIN Maestro.Moneda M ON M.ID = C.IdMoneda
													INNER JOIN Maestro.TipoCuenta TC ON TC.ID = C.IdTipoCuenta 
													LEFT JOIN ERP.PlanCuenta PC ON PC.ID = C.IdPlanCuenta
													WHERE C.ID = @IdCuenta)


	RETURN 	UPPER(@NombreBancoMonedaTipo)
END
