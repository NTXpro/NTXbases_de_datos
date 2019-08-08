CREATE PROC [ERP].[Usp_Sel_Comprobante_SinVale] --1

AS
BEGIN

SELECT * FROM ERP.Comprobante
WHERE Flag = 1 AND FlagBorrador = 0 
AND (DATEPART(yy, FechaModificado) = 2019 AND DATEPART(mm, FechaModificado) >= 02)
AND FlagControlarStock = 0
AND IdComprobanteEstado = 1
AND IdTipoComprobante = 202

END