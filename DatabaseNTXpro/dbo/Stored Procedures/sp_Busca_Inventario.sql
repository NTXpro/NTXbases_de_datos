-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Busca_Inventario
@IdEmpresa int,
@IdProyecto int,
@Fecha datetime

As
BEGIN
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select 
iif(C.GastadoSolesAñoAnterior is null, 0, C.GastadoSolesAñoAnterior) as GastadoSolesAñoAnterior_,
iif(C.GastadoSolesAñoPresente is null, 0, C.GastadoSolesAñoPresente) as GastadoSolesAñoPresente_,
iif(C.GastadoDolaresAñoAnterior is null,0, C.GastadoDolaresAñoAnterior) as GastadoDolaresAñoAnterior_,
iif(C.GastadoDolaresAñoPresente is null,0, C.GastadoDolaresAñoPresente) as GastadoDolaresAñoPresente_
from (
select 
-- B.ID, B.Fecha, B.Abreviatura, B.Nombre, B.CodigoSunat, B.TipoCambio,B.Cantidad, B.PrecioUnitario ,
SUM(iif(year(B.Fecha) <= datepart(year,@Fecha)-1 ,B.ImporteDetalle_Soles,0)) as GastadoSolesAñoAnterior,
SUM(iif(year(B.Fecha) = datepart(year,@Fecha) ,B.ImporteDetalle_Soles,0)) as GastadoSolesAñoPresente,
SUM(iif(year(B.Fecha) <= datepart(year,@Fecha)-1 ,B.ImporteDetalle_Dolares,0)) as GastadoDolaresAñoAnterior,
SUM(iif(year(B.Fecha) = datepart(year,@Fecha) ,B.ImporteDetalle_Dolares,0)) as GastadoDolaresAñoPresente

from (
SELECT A.ID, A.Fecha, A.Abreviatura, A.Nombre, A.CodigoSunat, A.TipoCambio, 
A.Cantidad, A.PrecioUnitario, 

IIf(a.CodigoSunat='PEN',a.Importe,a.Importe*a.TipoCambio) AS ImporteDetalle_Soles, 
IIf(a.CodigoSunat='USD',a.Importe,a.Importe/a.TipoCambio) AS ImporteDetalle_Dolares

FROM (SELECT ERP.Vale.ID, ERP.Vale.Fecha, Maestro.TipoMovimiento.Abreviatura, ERP.ValeDetalle.Nombre, 
Maestro.Moneda.CodigoSunat, ERP.Vale.TipoCambio, ERP.ValeDetalle.Cantidad, ERP.ValeDetalle.PrecioUnitario, 
ERP.ValeDetalle.SubTotal,
iif(Maestro.TipoMovimiento.Abreviatura='I',ERP.ValeDetalle.SubTotal*-1,ERP.ValeDetalle.SubTotal) as Importe
FROM ((ERP.Vale 
INNER JOIN Maestro.TipoMovimiento ON ERP.Vale.IdTipoMovimiento = Maestro.TipoMovimiento.ID) 
INNER JOIN ERP.ValeDetalle ON ERP.Vale.ID = ERP.ValeDetalle.IdVale) 
INNER JOIN Maestro.Moneda ON ERP.Vale.IdMoneda = Maestro.Moneda.ID
WHERE (((
ERP.Vale.Fecha)<=@Fecha) AND 
((ERP.Vale.IdEmpresa)=@IdEmpresa) AND 
((ERP.Vale.IdProyecto)=@IdProyecto) AND 
((ERP.Vale.Flag)=1) AND 
((ERP.Vale.FlagBorrador)=0)) ) AS A) as B) AS C


END