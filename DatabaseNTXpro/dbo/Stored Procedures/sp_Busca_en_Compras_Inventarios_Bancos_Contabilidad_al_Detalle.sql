-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Busca_en_Compras_Inventarios_Bancos_Contabilidad_al_Detalle]
	-- Add the parameters for the stored procedure here
	@IdEmpresa int,
	@IdProyecto int,
	@Fecha datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
Select D.Origen, D.Id, D.Nombre, D.Serie, D.Numero, D.FechaEmision as Fecha, D.CuentaContable as Cuenta,
D.ImporteDetalle_Soles as ImporteSoles, D.ImporteDetalle_Dolares as ImporteDolares, D.Cantidad
from(  
----------Compras -----------------------
select a.origen, a.id, a.nombre, a.serie, a.numero,a.FechaEmision, a.CuentaContable, 
--a.tipomoneda,a.tipocambio, a.ImporteDetalle,
iif(a.TipoMoneda='PEN', a.ImporteDetalle, a.ImporteDetalle*a.tipocambio) as ImporteDetalle_Soles,
iif(a.TipoMoneda='USD', a.ImporteDetalle, a.ImporteDetalle/a.tipocambio) as ImporteDetalle_Dolares,
0 as cantidad
from (
SELECT 'Compras' AS origen, cast(ERP.Compra.ID as varchar) as ID, ERP.Entidad.Nombre, ERP.Compra.Serie, 
ERP.Compra.Numero, ERP.Compra.FechaEmision, ERP.CompraDetalle.IdPlanCuenta, ERP.Compra.TipoCambio, 
iif(PLE.T10TipoComprobante.CodigoSunat ='07' ,ERP.CompraDetalle.Importe*-1,ERP.CompraDetalle.Importe) as ImporteDetalle,
ERP.Compra.IdMoneda, PLE.T10TipoComprobante.CodigoSunat, ERP.CompraDetalle.IdProyecto, 
Maestro.Moneda.CodigoSunat as TipoMoneda,ERP.PlanCuenta.CuentaContable
FROM ((((ERP.Compra INNER JOIN ERP.CompraDetalle ON ERP.Compra.ID = ERP.CompraDetalle.IdCompra) 
INNER JOIN Maestro.Moneda ON ERP.Compra.IdMoneda = Maestro.Moneda.ID) 
INNER JOIN ERP.Proveedor ON ERP.Compra.IdProveedor = ERP.Proveedor.ID) 
INNER JOIN ERP.Entidad ON ERP.Proveedor.IdEntidad = ERP.Entidad.ID) 
INNER JOIN PLE.T10TipoComprobante ON ERP.Compra.IdTipoComprobante = PLE.T10TipoComprobante.ID
inner join  ERP.PlanCuenta ON ERP.CompraDetalle.IdPlanCuenta =ERP.PlanCuenta.ID
WHERE ERP.Compra.IdEmpresa=@IdEmpresa and  ERP.CompraDetalle.IdProyecto= @IdProyecto and  
ERP.Compra.FechaEmision<= @Fecha and  ERP.Compra.Flag=1 and ERP.Compra.FlagBorrador=0 ) 
as A
-----------------------------------------------------------------------------------------
UNION
--------------------------
----------Inventario -----------------------
SELECT a.Origen, A.ID0, A.Nombre, A.Serie, A.Documento, A.Fecha, '' as CuentaContable,
--A.Abreviatura, A.CodigoSunat, A.TipoCambio,  A.PrecioUnitario
IIf(a.CodigoSunat='PEN',a.Importe,a.Importe*a.TipoCambio) AS ImporteDetalle_Soles, 
IIf(a.CodigoSunat='USD',a.Importe,a.Importe/a.TipoCambio) AS ImporteDetalle_Dolares,
A.Cantidad 
FROM (SELECT 'Inventarios' as Origen, concat (Maestro.TipoMovimiento.Abreviatura,cast(ERP.Vale.ID as varchar)) as ID0, 
ERP.Vale.Fecha,ERP.ValeDetalle.Nombre, Maestro.Moneda.CodigoSunat, ERP.Vale.TipoCambio, ERP.ValeDetalle.Cantidad, 
ERP.ValeDetalle.PrecioUnitario, ERP.ValeDetalle.SubTotal,  ERP.Vale.serie,  ERP.Vale.Documento,
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
((ERP.Vale.FlagBorrador)=0)) ) AS A
-------------------------------------------------------------------------
UNION
-----------------------------
--------Bancos----------------------------------------------------------
select A.origen,A.ID, A.Nombre, A.Serie, A.Documento, A.Fecha, A.CuentaContable,
A.ImporteDetalle_Soles, A.ImporteDetalle_Dolares, 0 as cantidad
from (
SELECT 'Bancos' AS origen, ERP.MovimientoTesoreriaDetalle.Nombre, ERP.PlanCuenta.CuentaContable, 
ERP.MovimientoTesoreriaDetalle.Serie, ERP.MovimientoTesoreriaDetalle.Documento, ERP.MovimientoTesoreria.Fecha, 
ERP.MovimientoTesoreria.TipoCambio, Maestro.Moneda.CodigoSunat, ERP.MovimientoTesoreriaDetalle.Total, cast(ERP.MovimientoTesoreria.ID as varchar) as ID,
iif(Maestro.Moneda.CodigoSunat='PEN',ERP.MovimientoTesoreriaDetalle.Total,ERP.MovimientoTesoreriaDetalle.Total*ERP.MovimientoTesoreria.TipoCambio) as ImporteDetalle_Soles,
iif(Maestro.Moneda.CodigoSunat='USD',ERP.MovimientoTesoreriaDetalle.Total,ERP.MovimientoTesoreriaDetalle.Total/ERP.MovimientoTesoreria.TipoCambio) as ImporteDetalle_Dolares
FROM (ERP.MovimientoTesoreria 
INNER JOIN ERP.MovimientoTesoreriaDetalle ON ERP.MovimientoTesoreria.ID = ERP.MovimientoTesoreriaDetalle.IdMovimientoTesoreria) 
INNER JOIN Maestro.Moneda ON ERP.MovimientoTesoreria.IdMoneda = Maestro.Moneda.ID
INNER JOIN  ERP.PlanCuenta ON ERP.MovimientoTesoreriaDetalle.IdPlanCuenta=ERP.PlanCuenta.ID
WHERE (((ERP.MovimientoTesoreria.Fecha)<=@Fecha) AND 
((ERP.MovimientoTesoreria.IdEmpresa)=@IdEmpresa) AND 
((ERP.MovimientoTesoreriaDetalle.IdProyecto)=@IdProyecto) AND 
((ERP.MovimientoTesoreria.Flag)=1) AND 
((ERP.MovimientoTesoreria.FlagBorrador)=0))) as A
---------------------------------------------------------------------------------
UNION
---------------------------------------------------
---------Contabilidad--------------------------------------- 
Select  A.Origen, A.Idorigen , A.Nombre, A.serie, A.Documento, A.Fecha,A.CuentaContable,
A.ImporteSoles, A.ImporteDolares, 0 as Contidad
from (
SELECT 'Contabilidad' AS origen, cast(ERP.Asiento.IdOrigen as varchar) as IdOrigen,  
ERP.AsientoDetalle.Nombre, ERP.Asiento.Fecha, ERP.PlanCuenta.CuentaContable, ERP.AsientoDetalle.Serie, 
ERP.AsientoDetalle.Documento, ERP.Asiento.IdMoneda, ERP.Asiento.TipoCambio, ERP.AsientoDetalle.ImporteSoles, 
ERP.AsientoDetalle.ImporteDolares
FROM ((ERP.Asiento 
INNER JOIN ERP.AsientoDetalle ON ERP.Asiento.ID = ERP.AsientoDetalle.IdAsiento) 
INNER JOIN ERP.PlanCuenta ON (ERP.AsientoDetalle.IdPlanCuenta = ERP.PlanCuenta.ID) AND (ERP.AsientoDetalle.IdPlanCuenta = ERP.PlanCuenta.ID)) 
INNER JOIN Maestro.Origen ON ERP.Asiento.IdOrigen = Maestro.Origen.ID
WHERE 
(((ERP.Asiento.Fecha)<=@Fecha) AND 
((ERP.AsientoDetalle.IdProyecto)=@IdProyecto) AND 
((ERP.Asiento.IdEmpresa)=@IdEmpresa) AND 
((ERP.Asiento.Flag)=1) AND 
((ERP.Asiento.FlagBorrador)=0) AND
left(ERP.PlanCuenta.CuentaContable,1)='9' and 
Maestro.Origen.Abreviatura in('01','09','17','18','19','21'))) as A ) as D 
Order by 
D.Origen asc,
 D.FechaEmision asc,
 D.Nombre asc


END