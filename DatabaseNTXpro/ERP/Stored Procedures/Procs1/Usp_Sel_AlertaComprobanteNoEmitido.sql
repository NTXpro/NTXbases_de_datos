-- =============================================
-- Author:		Omar Rodriguez
-- Create date: 26-06-2018 12:15am
-- Description:	Retorna la cantidad de comprobantes con 6 o mas dias de retraso para su emision.
--				
-- =============================================
CREATE PROC [ERP].[Usp_Sel_AlertaComprobanteNoEmitido]
@IdEmpresa INT,
@IdEstablecimiento INT
AS
BEGIN
	
	DECLARE @Cantidad INT = (SELECT count(*) as CANTIDAD
FROM ERP.Comprobante C
INNER JOIN Maestro.ComprobanteEstado CE ON CE.ID = C.IdComprobanteEstado
LEFT JOIN ERP.Proyecto P ON P.ID = C.IdProyecto
WHERE C.Flag = 1
	AND C.FlagBorrador = 0  
    AND C.IdEmpresa = @IdEmpresa
	AND C.IdTipoComprobante = 2 
	AND C.IdEstablecimiento = @IdEstablecimiento
	AND C.Serie LIKE 'F%'
	AND CE.Nombre ='REGISTRADO'
	AND DATEDIFF ( day , C.Fecha , GETDATE() )  >=6) 
	SELECT @Cantidad
END