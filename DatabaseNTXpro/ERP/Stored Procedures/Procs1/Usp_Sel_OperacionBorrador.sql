CREATE PROC ERP.Usp_Sel_OperacionBorrador
@IdEmpresa INT,
@IdAnio INT 
AS
BEGIN

		SELECT * FROM ERP.Operacion WHERE IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio AND FlagBorrador = 1  AND Flag = 1 
END
