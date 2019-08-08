CREATE PROC ERP.Usp_Sel_Ultimo_TipoCambio_Compra_By_Fecha
@Fecha DATETIME,
@IdEmpresa INT
AS
BEGIN

	DECLARE @UltimoTipoCambio DECIMAL(10,5)= (SELECT (SELECT ERP.ObtenerTipoCambioCompra_By_Sistema_Fecha(Valor,@Fecha)) as x
									FROM ERP.Parametro 
									WHERE IdEmpresa = @IdEmpresa AND Abreviatura = 'TCC' AND Valor = 'sunat')

	SELECT @UltimoTipoCambio 
END
