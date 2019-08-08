CREATE PROC ERP.Usp_Sel_OperacionInactivo
@IdEmpresa INT,
@IdAnio INT 
AS
BEGIN

		SELECT * FROM ERP.Operacion WHERE IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio AND FlagBorrador = 0  AND Flag = 0 
END
