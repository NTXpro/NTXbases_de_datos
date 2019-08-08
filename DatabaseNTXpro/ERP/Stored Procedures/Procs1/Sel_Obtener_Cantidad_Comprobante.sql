CREATE PROC [ERP].[Sel_Obtener_Cantidad_Comprobante]
@DESDE DATETIME,
@HASTA DATETIME,
@TIPO VARCHAR 

AS
BEGIN

IF @TIPO= 'F'
	select 

PLE.Descripcion as TipoComprobante,
count(C.Serie) 'Cantidad',
C.IdComprobanteEstado

from BD_ERP.ERP.Comprobante  C

INNER JOIN BD_ERP.PLE.T10TipoComprobante PLE  on  C.IdTipoComprobante= PLE.ID 


where  C.Serie LIKE 'F%%' and C.IdComprobanteEstado=2    and C.FechaRegistro between @DESDE  and @HASTA 
group BY PLE.Descripcion, c.IdComprobanteEstado


ELSE  


select 

PLE.Descripcion as TipoComprobante,
count(C.Serie) 'Cantidad'

from BD_ERP.ERP.Comprobante  C

INNER JOIN BD_ERP.PLE.T10TipoComprobante PLE  on  C.IdTipoComprobante= PLE.ID 


where  C.Serie LIKE 'B%%' And C.Flag= 1 AND C.FlagBorrador=0 and C.IdComprobanteEstado=2 and C.FechaRegistro between @DESDE   and @HASTA 
group BY PLE.Descripcion



END