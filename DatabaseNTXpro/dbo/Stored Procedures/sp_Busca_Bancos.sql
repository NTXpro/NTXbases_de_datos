-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Busca_Bancos
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
-- A.origen,A.Nombre,A.IdPlanCuenta,A.Serie,A.Documento,A.Fecha
sum(iif(year(A.Fecha) <= datepart(year,@Fecha)-1 ,A.ImporteDetalle_Soles,0)) as GastadoSolesAñoAnterior, 
sum(iif(year(A.Fecha) = datepart(year,@Fecha) ,A.ImporteDetalle_Soles,0)) as GastadoSolesAñoPresente,
sum(iif(year(A.Fecha) <= datepart(year,@Fecha)-1 ,A.ImporteDetalle_Dolares,0)) as GastadoDolaresAñoAnterior,
sum(iif(year(A.Fecha) = datepart(year,@Fecha) ,A.ImporteDetalle_Dolares,0)) as GastadoDolaresAñoPresente
from (
SELECT 'Banco' AS origen, ERP.MovimientoTesoreriaDetalle.Nombre, ERP.MovimientoTesoreriaDetalle.IdPlanCuenta, 
ERP.MovimientoTesoreriaDetalle.Serie, ERP.MovimientoTesoreriaDetalle.Documento, ERP.MovimientoTesoreria.Fecha, 
ERP.MovimientoTesoreria.TipoCambio, Maestro.Moneda.CodigoSunat, ERP.MovimientoTesoreriaDetalle.Total,
iif(Maestro.Moneda.CodigoSunat='PEN',ERP.MovimientoTesoreriaDetalle.Total,ERP.MovimientoTesoreriaDetalle.Total*ERP.MovimientoTesoreria.TipoCambio) as ImporteDetalle_Soles,
iif(Maestro.Moneda.CodigoSunat='USD',ERP.MovimientoTesoreriaDetalle.Total,ERP.MovimientoTesoreriaDetalle.Total/ERP.MovimientoTesoreria.TipoCambio) as ImporteDetalle_Dolares
FROM (ERP.MovimientoTesoreria 
INNER JOIN ERP.MovimientoTesoreriaDetalle ON ERP.MovimientoTesoreria.ID = ERP.MovimientoTesoreriaDetalle.IdMovimientoTesoreria) 
INNER JOIN Maestro.Moneda ON ERP.MovimientoTesoreria.IdMoneda = Maestro.Moneda.ID
WHERE (((ERP.MovimientoTesoreria.Fecha)<=@Fecha) AND 
((ERP.MovimientoTesoreria.IdEmpresa)=@IdEmpresa) AND 
((ERP.MovimientoTesoreriaDetalle.IdProyecto)=@IdProyecto) AND 
((ERP.MovimientoTesoreria.Flag)=1) AND 
((ERP.MovimientoTesoreria.FlagBorrador)=0))) as A) as C


END