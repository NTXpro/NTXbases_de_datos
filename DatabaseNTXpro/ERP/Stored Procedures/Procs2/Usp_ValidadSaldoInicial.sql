
CREATE PROC ERP.Usp_ValidadSaldoInicial
@IdProveedor INT,
@IdMoneda INT,
@IdTipoComprobante INT,
@Serie VARCHAR(50),
@Documento VARCHAR(50)
AS
BEGIN
	SELECT DISTINCT SI.ID
	FROM ERP.SaldoInicial SI
	WHERE SI.IdProveedor = @IdProveedor AND SI.IdMoneda = @IdMoneda AND SI.IdTipoComprobante = @IdTipoComprobante AND SI.Serie = @Serie 
	AND SI.Documento = @Documento AND SI.Flag = 1 AND SI.FlagBorrador = 0 
END
