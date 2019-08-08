
CREATE PROC [ERP].[Usp_Validar_Cuenta_Detraccion]
@IdCuenta INT,
@IdEmpresa INT
AS
BEGIN

	DECLARE @FlagCierre BIT = (SELECT C.FlagDetraccion
								FROM [ERP].[Cuenta] C
								WHERE  C.IdEmpresa = @IdEmpresa AND ID != @IdCuenta AND Flag = 1 AND FlagBorrador = 0 AND C.FlagDetraccion = 1)

	SELECT ISNULL(@FlagCierre,0)
END


--SELECT * FROM [ERP].[PeriodoSistema] PS
--SELECT * FROM ERP.PERIODO