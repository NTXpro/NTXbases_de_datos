-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Busca_Compras] 
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

select 
 iif(C.GastadoSolesAñoAnterior is null, 0, C.GastadoSolesAñoAnterior) as GastadoSolesAñoAnterior_,
 iif(C.GastadoSolesAñoPresente is null, 0, C.GastadoSolesAñoPresente) as GastadoSolesAñoPresente_,
 iif(C.GastadoDolaresAñoAnterior is null,0, C.GastadoDolaresAñoAnterior) as GastadoDolaresAñoAnterior_,
 iif(C.GastadoDolaresAñoPresente is null,0, C.GastadoDolaresAñoPresente) as GastadoDolaresAñoPresente_
from (
select  
--b.origen, b.id, b.nombre, b.serie, b.numero, b.FechaEmision, b.idplancuenta, b.tipomoneda, b.tipocambio, b.ImporteDetalle,
sum(iif(year(B.FechaEmision) <= datepart(year,@Fecha)-1 ,B.ImporteDetalle_Soles,0)) as GastadoSolesAñoAnterior,
sum(iif(year(B.FechaEmision) = datepart(year,@Fecha) ,B.ImporteDetalle_Soles,0)) as GastadoSolesAñoPresente,
sum(iif(year(B.FechaEmision) <= datepart(year,@Fecha)-1 ,B.ImporteDetalle_Dolares,0)) as GastadoDolaresAñoAnterior,
sum(iif(year(B.FechaEmision) = datepart(year,@Fecha) ,B.ImporteDetalle_Dolares,0)) as GastadoDolaresAñoPresente

from (
select a.origen, a.id, a.nombre, a.serie, a.numero, a.FechaEmision, a.idplancuenta, 
a.tipomoneda,a.tipocambio, a.ImporteDetalle,
iif(a.TipoMoneda='PEN', a.ImporteDetalle, a.ImporteDetalle*a.tipocambio) as ImporteDetalle_Soles,
iif(a.TipoMoneda='USD', a.ImporteDetalle, a.ImporteDetalle/a.tipocambio) as ImporteDetalle_Dolares
from (
SELECT 'Compra' AS origen, ERP.Compra.ID, ERP.Entidad.Nombre, ERP.Compra.Serie, 
ERP.Compra.Numero, ERP.Compra.FechaEmision, ERP.CompraDetalle.IdPlanCuenta, ERP.Compra.TipoCambio, 
iif(PLE.T10TipoComprobante.CodigoSunat ='07' ,ERP.CompraDetalle.Importe*-1,ERP.CompraDetalle.Importe) as ImporteDetalle,
ERP.Compra.IdMoneda, PLE.T10TipoComprobante.CodigoSunat, ERP.CompraDetalle.IdProyecto, Maestro.Moneda.CodigoSunat as TipoMoneda
FROM ((((ERP.Compra INNER JOIN ERP.CompraDetalle ON ERP.Compra.ID = ERP.CompraDetalle.IdCompra) 
INNER JOIN Maestro.Moneda ON ERP.Compra.IdMoneda = Maestro.Moneda.ID) 
INNER JOIN ERP.Proveedor ON ERP.Compra.IdProveedor = ERP.Proveedor.ID) 
INNER JOIN ERP.Entidad ON ERP.Proveedor.IdEntidad = ERP.Entidad.ID) 
INNER JOIN PLE.T10TipoComprobante ON ERP.Compra.IdTipoComprobante = PLE.T10TipoComprobante.ID
WHERE ERP.Compra.IdEmpresa=@IdEmpresa and  ERP.CompraDetalle.IdProyecto= @IdProyecto and  
ERP.Compra.FechaEmision<= @Fecha and  ERP.Compra.Flag=1 and ERP.Compra.FlagBorrador=0 ) 
as A) as B ) as C

END