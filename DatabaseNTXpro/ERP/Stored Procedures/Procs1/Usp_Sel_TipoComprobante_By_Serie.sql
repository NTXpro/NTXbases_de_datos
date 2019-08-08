
CREATE PROC ERP.Usp_Sel_TipoComprobante_By_Serie
@IdEmpresa INT,
@Serie CHAR(4)
AS
BEGIN
	DECLARE @IdTipoComprobante INT = (SELECT TOP 1 IdTipoComprobante FROM ERP.Comprobante 
									 WHERE Serie = @Serie AND FlagBorrador = 0 AND IdEmpresa = @IdEmpresa)

	SELECT ISNULL(@IdTipoComprobante,0);
END
