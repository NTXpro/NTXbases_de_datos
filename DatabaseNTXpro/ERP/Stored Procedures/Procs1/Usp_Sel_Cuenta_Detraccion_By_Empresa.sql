CREATE PROC ERP.Usp_Sel_Cuenta_Detraccion_By_Empresa
@IdEmpresa INT
AS
BEGIN
	SELECT ID,	
		   Nombre,
		   FlagDetraccion
	FROM ERP.Cuenta
	WHERE IdEmpresa = @IdEmpresa AND FlagBorrador= 0 AND Flag = 1 AND FlagDetraccion = 1
END