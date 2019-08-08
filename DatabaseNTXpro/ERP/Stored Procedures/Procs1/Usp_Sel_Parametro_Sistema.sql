CREATE PROC ERP.Usp_Sel_Parametro_Sistema
@Parametro VARCHAR(10)
AS
BEGIN
	DECLARE @Sistema VARCHAR(20) = (SELECT Valor FROM ERP.Parametro WHERE Abreviatura = @Parametro)

	SELECT @Sistema
END