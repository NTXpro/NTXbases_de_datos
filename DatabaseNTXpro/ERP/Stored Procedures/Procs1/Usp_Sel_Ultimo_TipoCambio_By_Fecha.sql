CREATE PROC [ERP].[Usp_Sel_Ultimo_TipoCambio_By_Fecha]
@Fecha DATETIME,
@IdEmpresa INT
AS
BEGIN

DECLARE @UltimoTipoCambio DECIMAL(10,5)= (SELECT (SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('TCV',@Fecha)) as x
FROM ERP.Parametro 
WHERE IdEmpresa = @IdEmpresa AND Abreviatura = 'TCV' AND Valor = 'Sunat')

SELECT @UltimoTipoCambio 
END