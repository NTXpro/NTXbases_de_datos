CREATE PROC ERP.Usp_Sel_Talonario
@IdEmpresa INT,
@IdCuenta INT
AS
BEGIN
	
	SELECT ID,
		   Inicio,
		   Fin
	FROM ERP.Talonario 
	WHERE IdEmpresa = @IdEmpresa AND IdCuenta = @IdCuenta
	 
END